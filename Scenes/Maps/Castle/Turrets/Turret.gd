extends StaticBody2D

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
	add_child(bullet)

### SIGNALS ###
func _on_Timer_timeout() -> void:
	sprite.play("shoot")
	_shoot_bullet()

func _on_TurretSprite_animation_finished():
	sprite.stop()
	shoot_timer.start()
