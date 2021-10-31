extends KinematicBody2D

################################################################################

# MOVEMENT
var move : Vector2 = Vector2.ZERO
var orientation : Vector2 = Vector2.ZERO
var speed : float = 500

# TARGET
var target_position : Vector2 = Vector2.ZERO

################################################################################

func _ready() -> void:
	orientation = target_position - get_global_position()
	rotation = orientation.angle()

func _physics_process(delta) -> void:
	handle_movement(delta)
	handle_collision()

func handle_movement(delta):
	move = Vector2.ZERO
	move = orientation.normalized() * speed
	move = move_and_slide(move)

func handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("player").has(node.collider):
			queue_free()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
