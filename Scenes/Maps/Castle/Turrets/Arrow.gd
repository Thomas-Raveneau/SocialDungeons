extends KinematicBody2D

################################################################################

# STATS
export var speed: float

# UTILS
var orientation: Vector2 = Vector2.ZERO

################################################################################

### PRIVATE ###
func _physics_process(_delta: float) -> void:
	_handle_movement()
	_handle_collision()

func _handle_movement() -> void:
	move_and_slide(orientation * speed * 100)

func _handle_collision() -> void:
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("wall").has(node.collider):
			destroy()

### PUBLIC ###
func destroy() -> void:
	queue_free()

func set_speed_and_dir(bullet_speed: float, bullet_dir: Vector2) -> void:
	speed = bullet_speed
	orientation = bullet_dir

### SIGNALS ###
func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()
