extends "res://Scenes/Projectile/AProjectile.gd"

# SCENES
var explosion_particles = preload("res://Scenes/Particles/Explosion.tscn")

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

func _generate_explosion() -> void:
	var explosion = explosion_particles.instance()
	explosion.global_position = Vector2(global_position.x, global_position.y)
	explosion.direction = orientation
	get_parent().add_child(explosion)

func _handle_collision():
	._handle_wall_collision()
	var slide_count = get_slide_count()
	for i in slide_count:
		_generate_explosion()		
		var collided_node = get_slide_collision(i)
		if (get_tree().get_nodes_in_group("player").has(collided_node.collider)):
			collided_node.collider.damage(DAMAGE, orientation)
			destroy()

############################# PRIVATE SIGNALS ##################################

func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()
