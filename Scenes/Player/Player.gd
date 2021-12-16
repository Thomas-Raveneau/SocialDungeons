extends KinematicBody2D

################################################################################

# SIGNALS
signal hp_changed(health)
signal killed()
signal spell(spell_num, cooldown)

# STATS
export var SPEED: int = 6 
export var DASH_SPEED: int = 15
export var MAX_HEALTH: int = 100
export var HEALTH: int = 100 setget _set_hp
export var DEFENSE: int = 5
export var ATTACK = 10
export var KNOCKBACK_FORCE = 3

# SPELLS STATS
export var BASIC_ATTACK_CURRENT_LEVEL: int = 0
export var BASIC_ATTACK_SPEED: float = 15.0
export var BASIC_ATTACK_DAMAGE: float = 8.0
export var BASIC_ATTACK_COOLDOWN: float = 0.5

export var PORTAL_SPEAR_ATTACK_CURRENT_LEVEL: int = 0
export var PORTAL_SPEAR_ATTACK_DAMAGE: float = 10.0
export var PORTAL_SPEAR_ATTACK_COOLDOWN: float = 2.0

export var LIGHTNING_ATTACK_CURRENT_LEVEL: int = 0
export var LIGHTNING_ATTACK_DAMAGE: float = 25.0
export var LIGHTNING_ATTACK_COOLDOWN: float = 1.5

# SPELLS TIMERS
onready var basic_attack_timer: Timer = $BasicAttackTimer
onready var portal_spear_attack_timer: Timer = $PortalSpearAttackTimer
onready var lightning_attack_timer: Timer = $LightningAttackTimer

# SPELLS UTILS
var can_basic_attack: bool = true
var can_portal_spear_attack: bool = true
var current_portal_spear_attack = null
var can_lightning_attack: bool = true

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
var last_step = -1
var is_falling: bool = false
var hole_damage: int = 10
onready var player_size: Vector2 = $Skin.get_sprite_frames().get_frame("idle", 0).get_size()

# NODES
onready var skin: AnimatedSprite = $Skin
onready var camera: Camera2D = get_parent().get_node('CameraScene')
onready var hitbox: CollisionShape2D = $Hitbox
onready var invicibility_timer: Timer = $Invicibility
onready var dash_duration_timer: Timer = $DashDuration
onready var dash_cooldown_timer: Timer = $DashCooldown
onready var damage_animation_timer: Timer = $DamageAnimation
onready var damage_particles_timer: Timer = $DamageParticlesTimer
onready var damage_sound: AudioStreamPlayer = $DamageSound
onready var damage_particles: CPUParticles2D = $DamageParticles

# SCENES
var damage_particle = preload("res://Scenes/Player/Effects/DamageParticle.tscn")
var step_particles = preload("res://Scenes/Particles/FootStep.tscn")
var blood_particles = preload("res://Scenes/Particles/Blood.tscn")
var basic_attack = preload("res://Scenes/Player/Spells/BasicAttack.tscn")
var dash_effect = preload("res://Scenes/Player/Effects/DashEffect.tscn")
var portal_spear_attack = preload("res://Scenes/Player/Spells/PortalSpear.tscn")
var lightning_attack = preload("res://Scenes/Player/Spells/Lightning.tscn")

################################################################################

### PRIVATE ###
func _ready() -> void:
	dash_duration_timer.wait_time = DASH_DURATION
	dash_cooldown_timer.wait_time = DASH_COOLDOWN
	dash_cooldown_timer.wait_time = DASH_COOLDOWN

	basic_attack_timer.wait_time = BASIC_ATTACK_COOLDOWN
	portal_spear_attack_timer.wait_time = PORTAL_SPEAR_ATTACK_COOLDOWN
	lightning_attack_timer.wait_time = LIGHTNING_ATTACK_COOLDOWN
	
	_set_hp(HEALTH)
	get_parent().get_skill_upgrade_node().connect("on_skill_updrade", self, "_on_skill_upgrade")

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	_handle_inputs()
	_handle_animations()
	_handle_walking_sound()
	_generate_particles()
	
	if (!is_taking_damage):
		velocity = move_and_slide(velocity * 100)
	else:
		velocity = move_and_slide(knockback * 100)
		camera.add_trauma(0.03)

	_handle_collisions()

func _generate_particles() -> void:
	_generate_walking_particles()
	_generate_blood_particles()	
	
func fall(hole: Vector2) -> void:
	$FallDuration.start()
	is_falling = true
	position = Vector2(hole.x, hole.y - player_size.y)

func _handle_fall_animation() -> void:
	if (is_falling and is_alive):
		self.scale = Vector2(self.scale.x - 0.04, self.scale.y - 0.04)
		self.rotation_degrees -= 0.5
		self.position.y += 0.35

func _generate_walking_particles() -> void:
	if ($Skin.animation == "run" and velocity != Vector2.ZERO):
		if ($Skin.get_frame() == 3 && last_step != 3):
			var dust = step_particles.instance()
			var offset_x = 0 if velocity.y != 0 else -32 if skin.flip_h else 32
			var offset_y = 50 if velocity.y > 0 else -10 if velocity.y < 0 else 32
			dust.global_position = Vector2(global_position.x + offset_x, global_position.y + offset_y)
			dust.process_material.direction = Vector3(-velocity.x, -velocity.y, 0)
			get_parent().add_child(dust)
		last_step = $Skin.get_frame()

func _generate_blood_particles() -> void:
	if (is_taking_damage and damage_particles_timer.time_left == 0.00000):
		damage_particles_timer.start()
		var blood = blood_particles.instance()
		blood.global_position = Vector2(global_position.x, global_position.y)
		blood.process_material.direction = Vector3(-knockback.x, -knockback.y, 0)
		get_parent().add_child(blood)

func _handle_walking_sound() -> void:
	if ($Skin.animation == "run"):
		if (!$WalkSound.playing and is_alive and !is_taking_damage):
			$WalkSound.play();
	else:
		$WalkSound.stop();

func _handle_collisions() -> void :
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var collided_node = get_slide_collision(i)
		if (get_tree().get_nodes_in_group("projectile").has(collided_node.collider)):
			pass
#			damage(1, collided_node.collider.orientation)
#			collided_node.collider.destroy()

func _dash() -> void:
	can_dash = false
	is_dashing = true
	dash_duration_timer.start()
	var dash_flame_effect = dash_effect.instance()
	dash_flame_effect.position = global_position
	dash_flame_effect.rotate(velocity.angle() + PI)
	get_parent().add_child(dash_flame_effect)

func _handle_movement_inputs() -> void:
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if (Input.is_action_just_pressed("action_dash") and can_dash == true and velocity != Vector2.ZERO):
		_dash()

	if (is_dashing):
		velocity = velocity.normalized() * DASH_SPEED
	else:
		velocity = velocity.normalized() * SPEED

func _handle_spells_inputs() -> void:
	if (Input.is_action_just_pressed("action_spell_01")):
		_basic_attack()
		emit_signal("spell", 1, BASIC_ATTACK_COOLDOWN);
	if (Input.is_action_just_pressed("action_spell_02")):
		_portal_spear_attack()
		emit_signal("spell", 2, PORTAL_SPEAR_ATTACK_COOLDOWN);
#	_handle_portal_spear_attack_inputs()
	if (Input.is_action_just_pressed("action_spell_03")):
		_lightning_attack()

func _basic_attack() -> void:
	if (!can_basic_attack):
		return
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var attack_dir: Vector2 = (mouse_pos - global_position).normalized()
	var new_axe = basic_attack.instance()
	
	new_axe.init_params(BASIC_ATTACK_DAMAGE, BASIC_ATTACK_SPEED, mouse_pos, global_position, BASIC_ATTACK_CURRENT_LEVEL)
	get_parent().add_child(new_axe)
	can_basic_attack = false
	basic_attack_timer.start()
	$ThrowAxe.play()

func _portal_spear_attack() -> void:
	if (!can_portal_spear_attack):
		return
	
	var player_pos: Vector2 = global_position
	var mouse_pos: Vector2 = get_global_mouse_position()
	var portal_direction: Vector2 = (mouse_pos - global_position).normalized()
	var portal_position: Vector2 = player_pos + (portal_direction * 50)
	
	current_portal_spear_attack = portal_spear_attack.instance()
	current_portal_spear_attack.init_params(PORTAL_SPEAR_ATTACK_DAMAGE, portal_position, portal_direction, PORTAL_SPEAR_ATTACK_CURRENT_LEVEL)
	
	can_portal_spear_attack = false
	portal_spear_attack_timer.start()
	
	get_parent().add_child(current_portal_spear_attack)

func _lightning_attack():
	if (!can_lightning_attack):
		return
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var lightning_dir: Vector2 = (mouse_pos - global_position).normalized()
	var new_lightning = lightning_attack.instance()
	
	new_lightning.init_params(LIGHTNING_ATTACK_DAMAGE, Vector2.ZERO, lightning_dir, LIGHTNING_ATTACK_CURRENT_LEVEL)
	add_child(new_lightning)
	
	can_lightning_attack = false
	lightning_attack_timer.start()

func _handle_inputs() -> void:
	velocity = Vector2()
	if (is_alive and !is_taking_damage and !is_falling):
		_handle_movement_inputs()
		_handle_spells_inputs()

func _handle_player_flip() -> void:
	if (velocity.x < 0 and !skin.flip_h):
		skin.flip_h = true
	if (velocity.x > 0 and skin.flip_h):
		skin.flip_h = false

func _handle_animations() -> void:
	_handle_fall_animation()
	
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
		skin.play("death")
#		skin.rotation_degrees = 90
		$DeathSound.play()
		$WalkSound.stop()
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
	
	damage_particles.emitting = true

func _handle_invicibility() -> void:
	invicibility_timer.start()
	is_invicible = true

func _handle_damage_sound() -> void:
	damage_sound.play()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_E:
			emit_signal("spell", 3, 10);
		if event.scancode == KEY_R:
			emit_signal("spell", 4, 5);

### PUBLIC ###
func damage(damage_amount: int, damage_dir: Vector2) -> bool: 
	if (is_invicible or is_dashing or !is_alive or is_falling):
		return false
	
	_handle_damage_animation(damage_amount, damage_dir)
	_handle_damage_sound()
	
	if (HEALTH - damage_amount <= 0):
		self.HEALTH = 0
		_handle_death()
		return true
	else:
		self.HEALTH -= damage_amount
		_set_hp(self.HEALTH)
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

func _set_hp(newHpValue: int) -> void:
	var prevHealth = HEALTH
	HEALTH = clamp(newHpValue, 0, MAX_HEALTH)
	if HEALTH != prevHealth:
		emit_signal("hp_changed", HEALTH)
		if HEALTH == 0:
			emit_signal("killed")

### SIGNALS ###
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

func _on_BasicAttackTimer_timeout():
	can_basic_attack = true

func _on_FallDuration_timeout():
	is_falling = false
	self.rotation_degrees = 0
	self.scale = Vector2(5, 5)
	self.damage(hole_damage, Vector2.ZERO)
	print(get_viewport().get_visible_rect().size)
	position = Vector2(get_viewport().get_visible_rect().size.x / 2, get_viewport().get_visible_rect().size.y / 1.15)

func _on_PortalSpearAttackTimer_timeout():
	can_portal_spear_attack = true

func _on_LightningAttackTimer_timeout():
	can_lightning_attack = true

func _on_Skin_animation_finished():
	if (skin.animation == "death"):
		skin.frame = 5
		skin.stop()

func _on_skill_upgrade(skill_to_upgrade: String) -> void:
	if (skill_to_upgrade == "basic_attack"):
		BASIC_ATTACK_CURRENT_LEVEL = 1
	if (skill_to_upgrade == "portal_spear"):
		PORTAL_SPEAR_ATTACK_CURRENT_LEVEL = 1
	if (skill_to_upgrade == "lightning"):
		LIGHTNING_ATTACK_CURRENT_LEVEL = 1
