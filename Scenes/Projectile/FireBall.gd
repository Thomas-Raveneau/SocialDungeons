extends "res://Scenes/Projectile/AProjectile.gd"

############################# PRIVATE METHODS ##################################

func _ready():
	rotation = orientation.angle()

func _physics_process(delta) -> void:
	_handle_movement()
	_handle_collision()

func _handle_movement():
	velocity = Vector2.ZERO
	velocity = orientation.normalized() * SPEED
	velocity = move_and_slide(velocity)

func _handle_collision():
	._handle_wall_collision()
	var slide_count = get_slide_count()
	for i in slide_count:
		var collided_node = get_slide_collision(i)
		if (get_tree().get_nodes_in_group("player").has(collided_node.collider)):
			collided_node.collider.damage(DAMAGE, orientation)
			destroy()

############################# PRIVATE SIGNALS ##################################

func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()
