extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED : float = 250
export var DASH_SPEED : float = 500
var velocity : Vector2 = Vector2.ZERO

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attacking : bool = false

var dash_vector : Vector2 = Vector2.ZERO
var is_dashing : bool = false

var is_dying : bool = false

onready var attack_cooldown : Timer = $DashTimer

# TARGET
onready var target : Node2D
onready var players_list : Array = get_tree().get_nodes_in_group("player")

# ANIMATION
onready var animation : AnimatedSprite = $Animation

################################################################################

func _physics_process(_delta) -> void:
	if !is_dying:
		handle_movement()
		handle_animation()
		handle_flip()
		handle_attack()

func handle_movement() -> void:
	velocity = Vector2.ZERO
	if target and !is_attacking:
		velocity = position.direction_to(target.position) * SPEED
	elif is_dashing:
		velocity = dash_vector * DASH_SPEED
	velocity = move_and_slide(velocity)

func handle_flip() -> void:
	if target and !is_attacking:
		if (velocity.x < 0 and !animation.flip_h):
			animation.flip_h = true
		if (velocity.x > 0 and animation.flip_h):
			animation.flip_h = false

func handle_animation() -> void:
	if (!is_attacking):
		if (velocity == Vector2(0, 0)):
			animation.play("idle")
		else:
			animation.play("walk")

func handle_attack() -> void:
	if in_range_of_attack and can_attack:
		can_attack = false
		is_attacking = true
		dash_vector = position.direction_to(target.position).normalized()
		animation.play("taunt")

func death() -> void:
	is_dying = true
	animation.play("death")

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
		attack_cooldown.start()
	elif animation.get_animation() == "death":
		queue_free()
