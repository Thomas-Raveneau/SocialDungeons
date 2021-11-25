extends "res://Scenes/Mobs/AMonster.gd"

############################# VARIABLES ########################################

# MOVEMENT
export var DODGE_SPEED = 200

# ACTION
var in_range_of_attack : bool = false
var can_attack : bool = true
var is_attacking  : bool = false
var is_dodging : bool = false

export var ATTACK_COOLDOWN : int = 0
onready var attack_timer : Timer = $AttackTimer

# COLLIDER
onready var hitbox : CollisionShape2D = $Hitbox

# ANIMATION
onready var animation : AnimatedSprite = $Animation

# PROJECTILE
onready var FIREBALL = preload("res://Scenes/Mobs/Projectile/FireBall.tscn")
onready var spawn_point : Node2D = $SpawnPoint

######################## PRIVATE METHODS #######################################

func _ready():
	attack_timer.wait_time = ATTACK_COOLDOWN
	attack_timer.start()

func _physics_process(_delta):
	if is_alive:
		_handle_movement()
		_handle_animation()
		_handle_flip()
		_handle_attack()
		_handle_collision()

func _handle_movement():
	if target:
		if !in_range_of_attack:
			velocity = position.direction_to(target.position) * SPEED
		elif is_dodging:
			velocity = position.direction_to(target.position) * DODGE_SPEED * -1
	velocity = move_and_slide(velocity)

func _handle_attack():
	if in_range_of_attack and can_attack and !is_dodging:
		is_attacking = true
		can_attack = false
		attack_timer.start()
		animation.play("attack")

func _handle_animation():
	if (!is_attacking):
		if (velocity == Vector2(0, 0)):
			animation.play("idle")
		else:
			animation.play("walk")

func _handle_flip():
	if target:
		var orientation = position.direction_to(target.position)
		orientation.x = orientation.x * -1 if is_dodging else orientation.x
		if (orientation.x < 0 and !animation.flip_h):
			animation.flip_h = true
			spawn_point.position.x = spawn_point.position.x * -1
		if (orientation.x > 0 and animation.flip_h):
			animation.flip_h = false
			spawn_point.position.x = spawn_point.position.x * -1

func _handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if hitbox.disabled or !node:
			continue
		if get_tree().get_nodes_in_group("projectile").has(node.collider):
			$DamageTimer.start()
			animation.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
			take_damage(node.collider.DAMAGE, node.collider.orientation)
			node.collider.destroy()

func _handle_death_animation() -> void:
	hitbox.disabled = true
	animation.play("death")

func _shoot_fireball():
		var bullet = FIREBALL.instance()
		bullet.position = spawn_point.get_global_position()
		bullet.orientation = target.position - spawn_point.get_global_position()
		
		get_parent().add_child(bullet)

####################### PUBLIC METHODS #########################################

######################## PRIVATE SIGNALS #######################################

func _on_DodgeArea_body_entered(body):
	if players_list.has(body):
		is_dodging = true
		in_range_of_attack = true
		target = players_list[players_list.find(body)]

func _on_DodgeArea_body_exited(body):
	if target == body:
		is_dodging = false

func _on_RangeArea_body_entered(body):
	if players_list.has(body):
		in_range_of_attack = true
		target = players_list[players_list.find(body)]

func _on_RangeArea_body_exited(body):
	if target == body:
		in_range_of_attack = false

func _on_DetectionArea_body_entered(body):
	if players_list.has(body):
		target = players_list[players_list.find(body)]

func _on_DetectionArea_body_exited(body):
	if target == body:
		target = null

func _on_AttackTimer_timeout():
	can_attack = true

func _on_Animation_animation_finished():
	if animation.get_animation() == "attack":
		is_attacking = false
		_shoot_fireball()
	elif animation.get_animation() == "death":
		is_attacking = false
		_handle_death()


func _on_DamageTimer_timeout() -> void:
	animation.self_modulate = Color(1, 1, 1)
	pass # Replace with function body.
