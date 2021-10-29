extends KinematicBody2D

################################################################################

# MOVEMENTS CONSTANTS
const SPEED: int = 6 * 100
const DASH_SPEED: int = 10 * 100

# TIMERS
const DASH_DURATION: float = 0.1
const DASH_COOLDOWN: float = 1.0

# UTILS
var can_dash: bool = true
var is_dashing: bool = false
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

func dash() -> void:
	can_dash = false
	is_dashing = true
	dash_duration_timer.start()

func handle_movement_inputs() -> void:
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
		dash()
	
	if (is_dashing):
		velocity = velocity.normalized() * DASH_SPEED
	else:
		velocity = velocity.normalized() * SPEED

func handle_inputs() -> void:
	handle_movement_inputs()

func handle_player_flip() -> void:
	if (velocity.x < 0 and !skin.flip_h):
		skin.flip_h = true
	if (velocity.x > 0 and skin.flip_h):
		skin.flip_h = false

func handle_animations() -> void:
	handle_player_flip()
	
	if (velocity == Vector2(0, 0)):
		skin.play('idle')
	else:
		skin.play('run')

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	handle_inputs()
	handle_animations()
	velocity = move_and_slide(velocity)

# SIGNALS
func _on_DashDuration_timeout() -> void:
	is_dashing = false
	dash_cooldown_timer.start()

func _on_DashCooldown_timeout() -> void:
	can_dash = true
