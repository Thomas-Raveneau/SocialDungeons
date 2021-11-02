extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED = 300
var velocity = Vector2.ZERO

# TARGET
var target
onready var players = get_tree().get_nodes_in_group("player")

# ANIMATION
onready var animation = $AnimatedSprite

# HEALTH
export var MAX_HEALTH : int = 15
var health : int = 0
var is_alive : bool = true

################################################################################

func _ready():
	pass

func _physics_process(_delta):
	if is_alive:
		handle_movement()
		handle_flip()
		handle_animation()
		handle_collision()

func handle_movement():
	velocity = Vector2.ZERO
	if target:
		velocity = position.direction_to(target.position) * SPEED
	velocity = move_and_slide(velocity)

func handle_flip():
	if (velocity.x < 0 and !animation.flip_h):
		animation.flip_h = true
	if (velocity.x > 0 and animation.flip_h):
		animation.flip_h = false

func handle_animation():
	if velocity == Vector2.ZERO:
		animation.play('idle')
	else:
		animation.play('run')

func handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("player").has(node.collider):
			damage(5, node.position)

func damage(damage_amount : int, damage_direction : Vector2):
	var orientation = damage_direction - get_global_position()
	health = health - damage_amount
	if health <= 0:
		death()

func death():
	is_alive = false
	queue_free()

func _on_DetectionArea_body_entered(body):
	players = get_tree().get_nodes_in_group("player")
	if players.has(body):
		target = players[players.find(body)]

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
