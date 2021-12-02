extends KinematicBody2D

################################### VARIABLES ##################################

# MOVEMENT
export var SPEED : int
var velocity : Vector2 = Vector2.ZERO

# DAMAGE
export var DAMAGE : int = 1
export var KNOCKBACK_FORCE : int = 3

# HEALTH AND LIFE
export var MAX_HEALTH : int
var health : int = 0
var is_alive : bool = true

# TARGET
onready var target
onready var players_list = get_tree().get_nodes_in_group("player")

#################################### SIGNALS ###################################

signal monster_death

############################# PRIVATE METHODS ##################################

func _ready() -> void:
	health = MAX_HEALTH

func _handle_death() -> void:
	emit_signal("monster_death")
	
	queue_free()

func _handle_death_animation() -> void:
	_handle_death()

func _handle_damage_animation(damage_orientation : Vector2) -> void:
	velocity = Vector2(0, 0)
	velocity = move_and_slide(damage_orientation.normalized() * KNOCKBACK_FORCE)
	pass

############################# PUBLIC METHODS ###################################

func take_damage(damage_amount : int, damage_orientation : Vector2) -> void:
	health = health - damage_amount
	if (health <= 0):
		is_alive = false
		_handle_death_animation()
	_handle_damage_animation(damage_orientation)
