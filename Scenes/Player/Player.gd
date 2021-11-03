extends KinematicBody2D

################################################################################

# SIGNALS
signal hp_changed(newHpValue)

# STATS
export var SPEED: int = 6 
export var DASH_SPEED: int = 15
export var MAX_HEALTH: int = 100
export var HEALTH: int = 100 setget set_hp
export var DEFENSE: int = 5
export var ATTACK = 10
export var KNOCKBACK_FORCE = 3

# DAMAGE PARTICLE UTILS
var damage_particle_dir = Vector2(0, -25)
var damage_particle_duration = 1
var damage_particle_spread = PI/2

# TIMERS
const DASH_DURATION: float = 0.1
const DASH_COOLDOWN: float = 1.0

# UTILS
var is_alive: bool = true
var can_dash: bool = true
var is_dashing: bool = false
var is_invicible: bool = false
var is_taking_damage: bool = false
var velocity: Vector2 = Vector2()
var knockback: Vector2 = Vector2()

# NODES
onready var skin: AnimatedSprite = $Skin
onready var hitbox: CollisionShape2D = $Hitbox
onready var invicibility_timer: Timer = $Invicibility
onready var dash_duration_timer: Timer = $DashDuration
onready var dash_cooldown_timer: Timer = $DashCooldown
onready var damage_animation_timer: Timer = $DamageAnimation
onready var damage_sound: AudioStreamPlayer = $DamageSound

# SCENES
var damage_particle = preload("res://Scenes/Player/DamageParticle.tscn")

################################################################################

### PRIVATE ###
func _ready() -> void:
	dash_duration_timer.wait_time = DASH_DURATION
	dash_cooldown_timer.wait_time = DASH_COOLDOWN

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	_handle_inputs()
	_handle_animations()
	if (!is_taking_damage):
		velocity = move_and_slide(velocity * 100)
	else:
		velocity = move_and_slide(knockback * 100)
	
	_handle_collisions()

func _handle_collisions() -> void :
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var collided_node = get_slide_collision(i)
		if (get_tree().get_nodes_in_group("projectile").has(collided_node.collider)):
			damage(1, collided_node.collider.orientation)
			collided_node.collider.destroy()

func _dash() -> void:
	can_dash = false
	is_dashing = true
	dash_duration_timer.start()

func _handle_movement_inputs() -> void:
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
	velocity = Vector2()
	if (is_alive and !is_taking_damage):
		_handle_movement_inputs()

func _handle_player_flip() -> void:
	if (velocity.x < 0 and !skin.flip_h):
		skin.flip_h = true
	if (velocity.x > 0 and skin.flip_h):
		skin.flip_h = false

func _handle_animations() -> void:
	if (is_alive):
		_handle_player_flip()
		
		if (is_taking_damage):
			skin.play('hit')
		elif (velocity == Vector2(0, 0)):
			skin.play('idle')
		else:
			skin.play('run')

func _handle_death() -> int:
	if (is_alive):
		is_alive = false
		skin.stop()
		skin.rotation_degrees = 90
		
		return 0
	else:
		return -1

func _handle_damage_animation(damage_amount: int, damage_dir: Vector2) -> void:
	damage_animation_timer.start()
	skin.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
	knockback = damage_dir.normalized() * KNOCKBACK_FORCE
	
	var damage_particle_node = damage_particle.instance()
	add_child(damage_particle_node)
	damage_particle_node.show_value(str(damage_amount), 
	damage_particle_dir, 
	damage_particle_duration, 
	damage_particle_spread, false)

func _handle_invicibility() -> void:
	invicibility_timer.start()
	is_invicible = true

func _handle_damage_sound() -> void:
	damage_sound.play()

### PUBLIC ###
func damage(damage_amount: int, damage_dir: Vector2) -> bool: 
	if (is_invicible or !is_alive):
		return false
	
	_handle_damage_animation(damage_amount, damage_dir)
	_handle_damage_sound()
	
	if (HEALTH - damage_amount <= 0):
		self.HEALTH = 0
		_handle_death()
		return true
	else:
		self.HEALTH -= damage_amount
		is_taking_damage = true
		_handle_invicibility()
		return false

func heal(heal_amount: int) -> int:
	if (!is_alive):
		return -1
	
	if (HEALTH + heal_amount > MAX_HEALTH):
		self.HEALTH = MAX_HEALTH
	else:
		self.HEALTH += heal_amount
	
	return 0

func revive(health_on_revive: int) -> int:
	if (is_alive):
		return -1
	
	HEALTH = health_on_revive
	is_alive = true
	
	return 0
	
func set_hp(newHpValue: int) -> void:
	HEALTH = newHpValue
	print('IN SET HP')
	emit_signal("hp_changed", newHpValue)

### SIGNALS ###
func _on_DashDuration_timeout() -> void:
	is_dashing = false
	dash_cooldown_timer.start()

func _on_DashCooldown_timeout() -> void:
	can_dash = true

func _on_Invicibility_timeout() -> void:
	is_invicible = false

func _on_DamageAnimation_timeout() -> void:
	skin.self_modulate = Color(1, 1, 1)
	is_taking_damage = false
