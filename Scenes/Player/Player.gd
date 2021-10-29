extends KinematicBody2D

################################################################################

# STATS
export var SPEED: int = 6 
export var DASH_SPEED: int = 10
export var MAX_HEALTH: int = 100
export var HEALTH: int = 100
export var DEFENSE: int = 5
export var ATTACK = 10

# TIMERS
const DASH_DURATION: float = 0.1
const DASH_COOLDOWN: float = 1.0

# UTILS
var can_dash: bool = true
var is_dashing: bool = false
var is_alive: bool = true
var velocity: Vector2 = Vector2()

# NODES
onready var skin: AnimatedSprite = $Skin
onready var hitbox: CollisionShape2D = $Hitbox
onready var dash_duration_timer: Timer = $DashDuration
onready var dash_cooldown_timer: Timer = $DashCooldown

################################################################################

func _ready() -> void:
	dash_duration_timer.wait_time = DASH_DURATION
	dash_cooldown_timer.wait_time = DASH_COOLDOWN

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	_handle_inputs()
	_handle_animations()
	velocity = move_and_slide(velocity * 100)

func _dash() -> void:
	can_dash = false
	is_dashing = true
	dash_duration_timer.start()

func _handle_movement_inputs() -> void:
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if (Input.is_action_just_pressed("action_dash") and can_dash == true):
		_dash()
	
	if (is_dashing):
		velocity = velocity.normalized() * DASH_SPEED
	else:
		velocity = velocity.normalized() * SPEED

func _handle_inputs() -> void:
	if (is_alive):
		_handle_movement_inputs()

func _handle_player_flip() -> void:
	if (velocity.x < 0 and !skin.flip_h):
		skin.flip_h = true
	if (velocity.x > 0 and skin.flip_h):
		skin.flip_h = false

func _handle_animations() -> void:
	if (is_alive):
		_handle_player_flip()
		
		if (velocity == Vector2(0, 0)):
			skin.play('idle')
		else:
			skin.play('run')

func _handle_death() -> int:
	if (is_alive):
		is_alive = false
		skin.stop()
		rotation_degrees = -90
		
		return 0
	else:
		return -1

func damage(damage_amount: int) -> bool:
	if (HEALTH - damage_amount <= 0):
		HEALTH = 0
		_handle_death()
		return true
	else:
		HEALTH -= damage_amount
		return false

func heal(heal_amount: int) -> int:
	if (!is_alive):
		return -1
	
	if (HEALTH + heal_amount > MAX_HEALTH):
		HEALTH = MAX_HEALTH
	else:
		HEALTH += heal_amount
	
	return 0

func revive(health_on_revive: int) -> int:
	if (is_alive):
		return -1
	
	HEALTH = health_on_revive
	is_alive = true
	
	return 0

### SIGNALS ###
func _on_DashDuration_timeout() -> void:
	is_dashing = false
	dash_cooldown_timer.start()

func _on_DashCooldown_timeout() -> void:
	can_dash = true
