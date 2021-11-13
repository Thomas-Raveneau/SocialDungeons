extends "res://Scenes/Mobs/Projectile/AProjectile.gd"

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

############################# PRIVATE SIGNALS ##################################

func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()
