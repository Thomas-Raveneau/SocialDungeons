extends StaticBody2D

################################################################################

# STATS
export var ARROW_SPEED: float = 10.0
export var ARROW_FREQUENCY: float = 1.0

# NODES
onready var shoot_timer: Timer = $ShootTimer
onready var sprite: AnimatedSprite = $TurretSprite

# SCENES
onready var Arrow = preload("res://Scenes/Maps/Castle/Turrets/Arrow.tscn")

# UTILS
var arrow_offset: int = 25

################################################################################

### PRIVATE ###
func _ready() -> void:
	shoot_timer.wait_time = ARROW_FREQUENCY
	shoot_timer.start()
	rotation_degrees = round(rotation_degrees)

func _shoot_arrow() -> void:
	var arrow = Arrow.instance()
	var arrow_dir: Vector2 = Vector2(cos(rotation), sin(rotation))
	
	arrow.position.x += arrow_offset 
	arrow.set_speed_and_dir(ARROW_SPEED, arrow_dir)
	
	add_child(arrow)

### SIGNALS ###
func _on_Timer_timeout() -> void:
	sprite.play("shoot")
	_shoot_arrow()

func _on_TurretSprite_animation_finished():
	sprite.stop()
	shoot_timer.start()
