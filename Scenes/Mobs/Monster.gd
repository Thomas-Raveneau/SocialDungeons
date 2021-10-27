extends KinematicBody2D

export var SPEED = 300
var velocity = Vector2.ZERO
var player

onready var players = get_tree().get_nodes_in_group("player")
onready var animation = $AnimatedSprite

func _ready():
	pass

func _physics_process(delta):
	velocity = Vector2.ZERO
	if (player):
		velocity = position.direction_to(player.position) * SPEED
	velocity = move_and_slide(velocity)
	_handle_flip()
	_handle_animation()

func _on_DetectionArea_body_entered(body):
	players = get_tree().get_nodes_in_group("player")
	if players.has(body):
		player = players[players.find(body)]

func _on_DetectionArea_body_exited(body):
	if body == player:
		player = null

func _handle_flip():
	if (velocity.x < 0 and !animation.flip_h):
		animation.flip_h = true
	if (velocity.x > 0 and animation.flip_h):
		animation.flip_h = false

func _handle_animation():
	if player == null:
		animation.play('idle')
	else:
		animation.play('run')
