extends "res://Scenes/Mobs/AMonster.gd"

########################### VARIABLES ##########################################

# COLLIDER
onready var hitbox : CollisionShape2D = $Hitbox

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attacking : bool = false

# DASH
export var DASH_SPEED : float = 500
export var DASH_COOLDOWN : int = 5
onready var dash_timer : Timer = $DashTimer
var dash_vector : Vector2 = Vector2.ZERO
var is_dashing : bool = false

# ANIMATION
onready var animation : AnimatedSprite = $Animation

######################## PRIVATE METHODS #######################################

func _ready():
	._ready()
	dash_timer.wait_time = DASH_COOLDOWN

func _physics_process(_delta) -> void:
	if is_alive:
		_handle_movement()
		_handle_attack()
		_handle_animation()
		_handle_flip()
		_handle_collision()

func _handle_movement() -> void:
	velocity = Vector2.ZERO
	if target and !is_attacking:
		velocity = position.direction_to(target.position) * SPEED
	elif is_dashing:
		velocity = dash_vector * DASH_SPEED
	velocity = move_and_slide(velocity)

func _handle_attack() -> void:
	if in_range_of_attack and can_attack:
		can_attack = false
		is_attacking = true
		dash_vector = position.direction_to(target.position).normalized()
		animation.play("taunt")

func _handle_flip() -> void:
	if target and !is_attacking:
		if (velocity.x < 0 and !animation.flip_h):
			animation.flip_h = true
		if (velocity.x > 0 and animation.flip_h):
			animation.flip_h = false

func _handle_animation() -> void:
	if (!is_attacking):
		if (velocity == Vector2(0, 0)):
			animation.play("idle")
		else:
			animation.play("walk")

func _handle_death_animation() -> void:
	hitbox.disabled = true
	animation.play("death")

func _handle_collision() -> void:
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if hitbox.disabled or !node:
			continue
		if get_tree().get_nodes_in_group("player").has(node.collider):
			_handle_hit_attack(node)
		if get_tree().get_nodes_in_group("projectile").has(node.collider):
			take_damage(node.collider.DAMAGE, node.collider.orientation)
			node.collider.destroy()

func _handle_hit_attack(node):
	if is_dashing:
		node.collider.damage(DAMAGE, position - node.collider.position)

######################### PUBLIC METHODS #######################################

func take_damage(damage_amount : int, damage_orientation : Vector2) -> void:
	if !is_dashing:
		.take_damage(damage_amount, damage_orientation)

######################### PRIVATE SIGNALS ######################################

func _on_DetectionArea_body_entered(body) -> void:
	if players_list.has(body):
		target = players_list[players_list.find(body)]

func _on_DetectionArea_body_exited(body) -> void:
	if target == body:
		target = null

func _on_RangeArea_body_entered(body) -> void:
	if target == body:
		in_range_of_attack = true

func _on_RangeArea_body_exited(body) -> void:
	if target == body:
		in_range_of_attack = false

func _on_DashTimer_timeout() -> void:
	can_attack = true

func _on_Animation_animation_finished() -> void:
	if animation.get_animation() == "taunt":
		animation.play("attack")
		is_dashing = true
	elif animation.get_animation() == "attack":
		is_dashing = false
		is_attacking = false
		dash_timer.start()
	elif animation.get_animation() == "death":
		queue_free()
