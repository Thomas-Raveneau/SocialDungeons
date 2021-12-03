extends "res://Scenes/Mobs/Projectile/AProjectile.gd"

### VARIABLES ###

# FIREBALL
onready var FIREBALL = preload("res://Scenes/Mobs/Projectile/FireBall.tscn")

# TIMER
onready var attack_timer : Timer = $AttackTimer

### PRIVATE METHODS ###

func _ready():
	attack_timer.start()

func _physics_process(delta):
	_handle_movement()
	_handle_collision()

func _handle_movement():
	velocity = Vector2.ZERO
	velocity = orientation.normalized() * SPEED
	velocity = move_and_slide(velocity)

func _handle_collision():
	._handle_wall_collision()

func _handle_attack():
	var orientation_fireball = Vector2(0, 1)
	_shoot_fireball(global_position, orientation_fireball.rotated(0), 500)
	_shoot_fireball(global_position, orientation_fireball.rotated(PI/3), 500)
	_shoot_fireball(global_position, orientation_fireball.rotated(2*PI/3), 500)
	_shoot_fireball(global_position, orientation_fireball.rotated(PI), 500)
	_shoot_fireball(global_position, orientation_fireball.rotated(4*PI/3), 500)
	_shoot_fireball(global_position, orientation_fireball.rotated(5*PI/3), 500)

func _shoot_fireball(spawn_position, orientation, speed):
	var bullet = FIREBALL.instance()
	bullet.position = spawn_position
	bullet.orientation = orientation
	bullet.SPEED = speed
	get_parent().add_child(bullet)

### PRIVATE SIGNALS ###

func _on_AttackTimer_timeout():
	attack_timer.start()
	_handle_attack()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
