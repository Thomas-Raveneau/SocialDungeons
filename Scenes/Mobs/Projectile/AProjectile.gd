extends KinematicBody2D

########################## VARIABLE ############################################

# MOVEMENT
export var SPEED : int = 200
var velocity : Vector2 = Vector2.ZERO
var orientation : Vector2 = Vector2.ZERO
var target_position : Vector2 = Vector2.ZERO

# DAMAGE
export var DAMAGE : int = 10

########################## PRIVATE METHODS #####################################

func _ready():
#	orientation = target_position - get_global_position()
#	rotation = orientation.angle()
	pass

func _handle_wall_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("wall").has(node.collider):
			destroy()

func _handle_destroy():
	queue_free()

func _handle_animation_destroy():
	_handle_destroy()

########################## PUBLIC METHODS #####################################

func destroy():
	_handle_animation_destroy()
