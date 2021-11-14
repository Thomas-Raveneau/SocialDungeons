extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED : float = 450
var velocity : Vector2 = Vector2.ZERO

# PROJECTILE
onready var FIREBALL = preload("res://Scenes/Mobs/Projectile/FireBall.tscn")
onready var NOVA = preload("res://Scenes/Mobs/Projectile/Nova.tscn")

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attack : bool = false

onready var cooldown_attack_1 : Timer = $CooldownAttack1
onready var cooldown_attack_2 : Timer = $CooldownAttack2

# PATTERNS
var attack_pattern : int = 0
onready var attack_pattern_timer : Timer = $PatternTimer

# HEALTH
var is_alive : bool = true

# ANIMATION
onready var animation : AnimatedSprite = $Animated

# TARGET
onready var target
onready var players_list = get_tree().get_nodes_in_group("player") 

# SPHERE
onready var sphere_node : Node2D = $MageSphere
var sphere_orientation : Vector2 = Vector2.ZERO
var sphere_distance : float = 150

################################################################################

func _ready():
	randomize()
	attack_pattern = randi() % 3
	cooldown_attack_1.start()
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
	if is_attack:
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
	cooldown_attack_1.start()
	cooldown_attack_2.start()

func _on_CooldownAttack1_timeout():
	if attack_pattern == 0:
		can_attack = true

func _on_CooldownAttack2_timeout():
	if attack_pattern == 1:
		can_attack = true

func _on_Animated_animation_finished():
	if animation.get_animation() == "attack":
		is_attack = false
		animation.speed_scale = 1
		if attack_pattern == 0:
			_handle_attack_execution_1()
		elif attack_pattern == 1:
			_handle_attack_execution_2()
		elif attack_pattern == 2:
			_handle_attack_execution_3()

