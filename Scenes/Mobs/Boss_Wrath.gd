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

var attack_pattern : int = 0
onready var attack_pattern_timer : Timer = $PatternTimer

# HEALTH
var is_alive : bool = true

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
	pass

func _handle_flip():
	pass

func _handle_movement():
	velocity = Vector2.ZERO
	velocity = Vector2(10,10)
	velocity = move_and_slide(velocity)

func _handle_attack():
	if attack_pattern == 0:
		_handle_attack_1()
	elif attack_pattern == 1:
		_handle_attack_2()
	elif attack_pattern == 2:
		_handle_attack_3()

func _handle_attack_1():
	pass

func _handle_attack_2():
	pass

func _handle_attack_3():
	pass

func _handle_sphere():
	if target:
		sphere_orientation = (position - target.position).normalized() * -1
		sphere_node.position = (sphere_orientation * sphere_distance)

##################### PRIVATE SIGNALS ##########################################

func _on_DetectionArea_body_entered(body):
	if players_list.has(body):
		target = players_list[players_list.find(body)]


func _on_PatternTimer_timeout():
	print(attack_pattern)
	attack_pattern = randi() % 3
	attack_pattern_timer.start()
