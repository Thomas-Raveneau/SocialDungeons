extends KinematicBody2D

################################################################################

# PREFAB
onready var FIREBALL = preload("res://Scenes/Mobs/Projectile/FireBall.tscn")

# MOVEMENT
export var SPEED = 250
export var DODGE_SPEED = 200
var velocity : Vector2 = Vector2.ZERO

# ACTION
var in_range_of_attack : bool = false
var can_attack : bool = true
var is_attacking  : bool = false
var is_dodging : bool = false

onready var attack_cooldown : Timer = $Attack_Cooldown

# TARGET
onready var target
onready var players_list = get_tree().get_nodes_in_group("player")

# ANIMATION
onready var animation : AnimatedSprite = $Animation
onready var spawn_point : Node2D = $SpawnPoint

# HEALTH
export var MAX_HEALTH : int = 15

var is_alive : bool = true
var health : int = 0

################################################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_cooldown.start()
	health = MAX_HEALTH

func _physics_process(_delta):
	if is_alive:
		handle_movement()
		handle_animation()
		handle_flip()
		handle_attack()
		handle_collision()

func handle_movement():
	velocity = Vector2.ZERO
	if target:
		if !in_range_of_attack:
			velocity = position.direction_to(target.position) * SPEED
		elif is_dodging:
			velocity = position.direction_to(target.position) * DODGE_SPEED * -1
	velocity = move_and_slide(velocity)

func handle_attack():
	if in_range_of_attack and can_attack and !is_dodging:
		is_attacking = true
		can_attack = false
		attack_cooldown.start()
		animation.play("attack")

func handle_animation():
	if (!is_attacking):
		if (velocity == Vector2(0, 0)):
			animation.play("idle")
		else:
			animation.play("walk")

func handle_flip():
	if target:
		var orientation = position.direction_to(target.position)
		orientation.x = orientation.x * -1 if is_dodging else orientation.x
		if (orientation.x < 0 and !animation.flip_h):
			animation.flip_h = true
			spawn_point.position.x = spawn_point.position.x * -1
		if (orientation.x > 0 and animation.flip_h):
			animation.flip_h = false
			spawn_point.position.x = spawn_point.position.x * -1

func handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("projectile").has(node.collider):
			damage(5, node.position.angle() + PI)

func damage(damage_amount : int, damage_direction : Vector2):
	health = health - damage_amount
	if health <= 0:
		death()

func death():
	is_alive = false
	animation.play("death")

func fire():
		var bullet = FIREBALL.instance()
		bullet.position = spawn_point.get_global_position()
		bullet.target_position = target.position
		get_parent().add_child(bullet)

func _on_DodgeArea_body_entered(body):
	if target == body:
		is_dodging = true

func _on_DodgeArea_body_exited(body):
	if target == body:
		is_dodging = false

func _on_RangeArea_body_entered(body):
	if target == body:
		in_range_of_attack = true

func _on_RangeArea_body_exited(body):
	if target == body:
		in_range_of_attack = false

func _on_DetectionArea_body_entered(body):
	if players_list.has(body):
		target = players_list[players_list.find(body)]

func _on_DetectionArea_body_exited(body):
	if target == body:
		target = null

func _on_Attack_Cooldown_timeout():
	can_attack = true

func _on_Animation_animation_finished():
	is_attacking = false
	if animation.get_animation() == "attack":
		fire()
	elif animation.get_animation() == "death":
		queue_free()
