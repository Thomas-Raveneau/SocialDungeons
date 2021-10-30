extends Area2D

################################################################################

# MOVEMENT
var move : Vector2 = Vector2.ZERO
var orientation : Vector2 = Vector2.ZERO
var speed : float = 8

# TARGET
var target_position : Vector2 = Vector2.ZERO

################################################################################

func _ready() -> void:
	orientation = target_position - get_global_position()
	rotation = orientation.angle()
	pass

func _physics_process(delta) -> void:
	move = Vector2.ZERO
	move = move.move_toward(orientation, delta)
	move = move.normalized() * speed
	position += move

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
