extends KinematicBody2D

### VARIABLES ###

# CONSTANT #
export var SPEED : float = 10.0
export var DAMAGE : float = 10.0
export var MAX_HEALTH : float = 50.0

# LIFE #
var health : float = 0
var is_alive : bool = true

# TARGET #
var player
onready var players = get_tree().get_nodes_in_group("player")

### PRIVATE METHODS ###

func _ready() -> void:
	health = MAX_HEALTH

### PUBLIC METHODS ###

func take_damage(damage_amount : int, damage_orientation : Vector2) -> void:
	pass
