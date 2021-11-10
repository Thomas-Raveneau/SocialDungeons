extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED : float = 450
var velocity : Vector2 = Vector2.ZERO

# FIREBALL
onready var FIREBALL = preload("res://Scenes/Mobs/Projectile/FireBall.tscn")
onready var spawn_point : Node2D = $SpawnPoint

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attack : bool = false

onready var cooldown_attack_1 : Timer = $CooldownAttack1

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
		_handle_attack_1()
	elif attack_pattern == 2:
		_handle_attack_1()

func _handle_attack_1():
	if in_range_of_attack and can_attack and target and !is_attack:
		is_attack = true
		can_attack = false
		cooldown_attack_1.start()
		animation.play("attack")
		animation.speed_scale = 2

func _handle_attack_2():
	pass

func _handle_attack_3():
	pass

func _handle_sphere():
	if target:
		sphere_orientation = (position - target.position).normalized() * -1
		sphere_node.position = (sphere_orientation * sphere_distance)

func _shoot_fireball():
		var bullet = FIREBALL.instance()
		bullet.position = sphere_node.global_position
		bullet.target_position = target.position
		bullet.SPEED = 1200
		get_parent().add_child(bullet)

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

func _on_CooldownAttack1_timeout():
	can_attack = true

func _on_Animated_animation_finished():
	if animation.get_animation() == "attack":
		is_attack = false
		animation.speed_scale = 1
		_shoot_fireball()
