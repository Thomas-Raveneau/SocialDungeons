extends KinematicBody2D

################################################################################

# MOVEMENT
export var SPEED = 250
export var DASH_SPEED = 200

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = false
var is_attacking : bool = false

# TARGET
onready var target
onready var players_list = get_tree().get_nodes_in_group("player")

# ANIMATION
onready var animation = $Animation

################################################################################

func _ready():
	pass # Replace with function body.

