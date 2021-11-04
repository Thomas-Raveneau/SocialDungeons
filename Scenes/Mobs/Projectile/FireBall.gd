extends KinematicBody2D

################################################################################

# MOVEMENT
var move : Vector2 = Vector2.ZERO
var orientation : Vector2 = Vector2.ZERO
var speed : float = 500

# TARGET
var target_position : Vector2 = Vector2.ZERO

################################################################################

### PRIVATE ###
func _ready() -> void:
	orientation = target_position - get_global_position()
	rotation = orientation.angle()

func _physics_process(delta) -> void:
	_handle_movement(delta)
	_handle_collision()

func _handle_movement(delta):
	move = Vector2.ZERO
	move = orientation.normalized() * speed
	move = move_and_slide(move)

func _handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("wall").has(node.collider):
			destroy()

### PUBLIC ###
func destroy(): 
	queue_free()

### SIGNALS ###
func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()
