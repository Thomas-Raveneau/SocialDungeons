extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED : float = 450
var velocity : Vector2 = Vector2.ZERO

onready var hitbox : CollisionShape2D = $Hitbox

# PROJECTILE
onready var FIREBALL = preload("res://Scenes/Projectile/FireBall.tscn")
onready var NOVA = preload("res://Scenes/Projectile/Nova.tscn")

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attack : bool = false
var is_taking_damage  : bool = false

export var COOLDOWN_VALUE_1 : float = 0
onready var cooldown_attack_1 : Timer = $CooldownAttack1
export var COOLDOWN_VALUE_2 : float = 0
onready var cooldown_attack_2 : Timer = $CooldownAttack2

# PATTERNS
var attack_pattern : int = 0
onready var attack_pattern_timer : Timer = $PatternTimer

# LIFE #
var health : float = 0
var is_alive : bool = true
export var MAX_HEALTH : float = 50.0

# ANIMATION
onready var animation : AnimatedSprite = $Animated

# TARGET
onready var target
onready var players_list = get_tree().get_nodes_in_group("player") 

# SPHERE
onready var sphere_node : Node2D = $Orbe
var sphere_orientation : Vector2 = Vector2.ZERO
var sphere_distance : float = 150

################################################################################

func _ready():
	health = MAX_HEALTH
	randomize()
	attack_pattern = randi() % 3
	cooldown_attack_1.wait_time = 0
	cooldown_attack_1.start()
	cooldown_attack_2.wait_time = 0
	cooldown_attack_2.start()

func _process(delta):
	pass

func _physics_process(delta):
	if is_alive:
		_handle_movement()
		_handle_animation()
		_handle_attack()
		_handle_flip()
		_handle_sphere()

func _handle_animation():
	$Orbe/AnimatedSprite.play("idle")
	if is_taking_damage:
		animation.play("hurt")
	elif is_attack:
		animation.play("attack")
	elif velocity == Vector2.ZERO:
		animation.play('idle')
	else:
		animation.play('run')

func _handle_flip():
	if (velocity.x < 0 and !animation.flip_h):
		animation.flip_h = true
	if (velocity.x > 0 and animation.flip_h):
		animation.flip_h = false

func _handle_movement():
	pass

func _handle_attack():
	if attack_pattern == 0:
		_handle_attack_1()
	elif attack_pattern == 1:
		_handle_attack_2()
	elif attack_pattern == 2:
		_handle_attack_3()

func _handle_attack_1():
	if in_range_of_attack and can_attack and target and !is_attack:
		is_attack = true
		can_attack = false
		cooldown_attack_1.start()
		animation.play("attack")
		animation.speed_scale = 2

func _handle_attack_2():
	if in_range_of_attack and can_attack and target and !is_attack:
		is_attack = true
		can_attack = false
		cooldown_attack_2.start()
		animation.play("attack")

func _handle_attack_3():
	pass

func _handle_attack_execution_1():
	_shoot_fireball(sphere_node.global_position, (target.position - sphere_node.global_position), 1200)

func _handle_attack_execution_2():
	_shoot_nova(sphere_node.global_position, (target.position - sphere_node.global_position), 100)

func _handle_attack_execution_3():
	pass

func _handle_sphere():
	if target:
		sphere_orientation = (position - target.position).normalized() * -1
		sphere_node.position = (sphere_orientation * sphere_distance)

func _shoot_fireball(spawn_position, orientation, speed):
		var fireball = FIREBALL.instance()
		fireball.position = spawn_position
		fireball.orientation = orientation
		fireball.SPEED = speed
		get_parent().add_child(fireball)

func _shoot_nova(spawn_position, orientation, speed):
		var nova = NOVA.instance()
		nova.position = spawn_position
		nova.orientation = orientation
		nova.SPEED = speed
		get_parent().add_child(nova)

func _handle_death_animation() -> void:
	hitbox.disabled = true
	animation.play("death")
	$Orbe/AnimatedSprite.play("death")

func _handle_damage_animation(damage_orientation : Vector2) -> void:
	if (!is_attack):
		animation.play("hurt")
		animation.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
		is_taking_damage = true

##################### PUBLIC METHODS ##########################################

func take_damage(damage_amount : int, damage_orientation : Vector2, knockback_force : int, spell_state : String) -> void:
	health = health - damage_amount
	if (health <= 0):
		is_alive = false
		_handle_death_animation()
	else:
		_handle_damage_animation(damage_orientation)

##################### PRIVATE SIGNALS ##########################################

func _on_DetectionArea_body_entered(body):
	if players_list.has(body):
		target = players_list[players_list.find(body)]

func _on_DetectionArea_body_exited(body):
	if target == body:
		target = null

func _on_RangeArea_body_entered(body):
	if target == body:
		in_range_of_attack = true

func _on_RangeArea_body_exited(body):
	if target == body:
		in_range_of_attack = false

func _on_PatternTimer_timeout():
	attack_pattern = randi() % 3
	attack_pattern_timer.start()
	cooldown_attack_1.wait_time = 0
	cooldown_attack_1.start()
	cooldown_attack_2.wait_time = 0
	cooldown_attack_2.start()

func _on_CooldownAttack1_timeout():
	cooldown_attack_1.wait_time = COOLDOWN_VALUE_1
	if attack_pattern == 0:
		can_attack = true

func _on_CooldownAttack2_timeout():
	cooldown_attack_2.wait_time = COOLDOWN_VALUE_2
	if attack_pattern == 1:
		can_attack = true

func _on_Animated_animation_finished():
	animation.speed_scale = 1
	if animation.get_animation() == "attack":
		is_attack = false
		if attack_pattern == 0:
			_handle_attack_execution_1()
		elif attack_pattern == 1:
			_handle_attack_execution_2()
		elif attack_pattern == 2:
			_handle_attack_execution_3()
	elif animation.get_animation() == "hurt":
		animation.self_modulate = Color(1,1,1)
		is_taking_damage = false
	elif animation.get_animation() == "death":
		animation.self_modulate = Color(1,1,1)
