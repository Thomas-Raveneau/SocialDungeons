extends Area2D

################################################################################

# STATS
export var BULLET_SPEED: float = 10.0
export var BULLET_FREQUENCY: float = 1.0

# NODES
onready var shoot_timer: Timer = $ShootTimer
onready var sprite: AnimatedSprite = $TurretSprite

# SCENES
onready var Bullet = preload("res://Scenes/Maps/Castle/Turrets/Bullet.tscn")

################################################################################

### PRIVATE ###
func _ready() -> void:
	shoot_timer.wait_time = BULLET_FREQUENCY
	shoot_timer.start()

func _shoot_bullet() -> void:
	var bullet = Bullet.instance()
	var bullet_dir: Vector2 = Vector2(cos(rotation), sin(rotation))
	bullet.set_speed_and_dir(BULLET_SPEED, bullet_dir)
	
	var texture = sprite.frames.get_frame("default", 0)
	bullet.rotation = rotation
	
	if (int(sprite.rotation_degrees) == 0):
		bullet.position = Vector2(texture.get_size().x / 2, 0)
	elif (int(sprite.rotation_degrees) == 180):
		bullet.position = Vector2(-texture.get_size().x / 2 , 0)
	elif (int(sprite.rotation_degrees) == 90):
		bullet.position = Vector2(0 , texture.get_size().y / 2)
	else:
		bullet.position = Vector2(0 , -texture.get_size().y / 2)
		
	add_child(bullet)
	
	

### SIGNALS ###
func _on_Timer_timeout() -> void:
	_shoot_bullet()
