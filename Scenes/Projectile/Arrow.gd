extends "res://Scenes/Projectile/AProjectile.gd"

################################################################################

# STATS

################################################################################

### PRIVATE ###
func _ready():
	
	pass

func _physics_process(_delta: float) -> void:
	_handle_movement()
	_handle_collision()

func _handle_movement() -> void:
	move_and_slide(orientation * SPEED)

func _handle_collision() -> void:
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("wall").has(node.collider):
			destroy()
		var collided_node = get_slide_collision(i)
		if (get_tree().get_nodes_in_group("player").has(collided_node.collider)):
			collided_node.collider.damage(DAMAGE, orientation)
			destroy()		

### PUBLIC ###
func destroy() -> void:
	queue_free()

func set_speed_and_dir(bullet_speed: float, bullet_dir: Vector2) -> void:
	SPEED = bullet_speed
	orientation = bullet_dir

### SIGNALS ###
func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()
