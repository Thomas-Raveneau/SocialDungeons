extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED : float = 450
var velocity : Vector2 = Vector2.ZERO

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attack : bool = false

onready var attack_cooldown : Timer = $AttackCooldown

# HEALTH
var is_alive : bool = true

################################################################################

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	if is_alive:
		handle_movement()
		handle_animation()
		handle_attack()
		handle_flip()

func handle_animation():
	pass

func handle_flip():
	pass

func handle_movement():
	pass

func handle_attack():
	pass
