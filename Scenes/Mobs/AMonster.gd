extends KinematicBody2D

################################### VARIABLES ##################################

enum WEIGHT_CLASS {
	LIGHT = 3,
	STANDARD = 2,
	HEAVY = 1,
	IMMOVABLE = 0
}

# MOVEMENT
export var SPEED : int
export var CURRENT_WEIGHT_CLASS: int
var velocity : Vector2 = Vector2.ZERO
var direction_hit: Vector2 = Vector2.ZERO
# DAMAGE
export var DAMAGE : int = 1

# HEALTH AND LIFE
export var MAX_HEALTH : int
var health : int = 0
var is_alive : bool = true

# TARGET
onready var player
onready var players = get_tree().get_nodes_in_group("player")

#################################### SIGNALS ###################################

signal monster_death

############################# PRIVATE METHODS ##################################

func _ready() -> void:
	player = players[0]
	health = MAX_HEALTH
	CURRENT_WEIGHT_CLASS = WEIGHT_CLASS.IMMOVABLE
	
func _handle_death() -> void:
	emit_signal("monster_death")
	queue_free()

func _handle_death_animation() -> void:
	_handle_death()

func _handle_damage_animation(damage_orientation : Vector2, knockback_force : int, spell_state : String) -> void:
	velocity = Vector2(0, 0)
	velocity = move_and_slide(damage_orientation.normalized() * knockback_force)

############################# PUBLIC METHODS ###################################

func get_knockback_multiplier() -> Vector2:
	if (CURRENT_WEIGHT_CLASS != WEIGHT_CLASS.IMMOVABLE):
		return Vector2(float(CURRENT_WEIGHT_CLASS / 2), float(CURRENT_WEIGHT_CLASS / 2))
	return Vector2(WEIGHT_CLASS.IMMOVABLE, WEIGHT_CLASS.IMMOVABLE)

func take_damage(damage_amount : int, damage_orientation : Vector2, knockback_force : int, spell_state : String) -> void:
	health = health - damage_amount
	if (health <= 0):
		is_alive = false
		_handle_death_animation()
	_handle_damage_animation(damage_orientation, knockback_force, spell_state)
