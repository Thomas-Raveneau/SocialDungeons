extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED = 250
export var DASH_SPEED = 200
var velocity : Vector2 = Vector2.ZERO

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attacking : bool = false

var dash_vector : Vector2 = Vector2.ZERO
var is_dashing : bool = false

onready var attack_cooldown : Timer = $Attack_Cooldown

# TARGET
onready var target
onready var players_list = get_tree().get_nodes_in_group("player")

# ANIMATION
onready var animation = $Animation

################################################################################

func _physics_process(delta):
	handle_movement()
	handle_flip()
	handle_animation()
	handle_attack()

func handle_movement():
	velocity = Vector2.ZERO
	if target:
		if !is_attacking:
			velocity = position.direction_to(target.position) * SPEED
		if is_dashing:
			velocity = dash_vector * DASH_SPEED
	velocity = move_and_slide(velocity)

func handle_flip():
	if target and !is_attacking:
		if (velocity.x < 0 and !animation.flip_h):
			animation.flip_h = true
		if (velocity.x > 0 and animation.flip_h):
			animation.flip_h = false

func handle_animation():
	if (!is_attacking):
		if (velocity == Vector2(0, 0)):
			animation.play("idle")
		else:
			animation.play("walking")

func handle_attack():
	if in_range_of_attack and can_attack:
		can_attack = false
		is_attacking = true
		dash_vector = position.direction_to(target.position).normalized()
		animation.play("taunt")

func _on_DetectionArea_body_entered(body):
	if players_list.has(body):
		target = players_list[players_list.find(body)]

func _on_DetectionArea_body_exited(body):
	if target == body:
		target = null

func _on_RangeArea_body_entered(body):
	if target == body:
		in_range_of_attack = true

func _on_RangeArea_body_exited(body):
	if target == body:
		in_range_of_attack = false

func _on_DashTimer_timeout():
	can_attack = true

func _on_Animation_animation_finished():
	if animation.animation == "taunt":
		animation.play("attack")
		is_dashing = true
	if animation.animation == "attack":
		attack_cooldown.start()
		is_dashing = false
		is_attacking = false
