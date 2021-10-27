extends Area2D

var move : Vector2 = Vector2.ZERO
var target_position : Vector2 = Vector2.ZERO
var orientation : Vector2 = Vector2.ZERO
var speed : float = 8

func _ready():
	orientation = target_position - get_global_position()
	rotation = orientation.angle()
	pass


#func _process(delta):
#	pass

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(orientation, delta)
	move = move.normalized() * speed
	position += move
