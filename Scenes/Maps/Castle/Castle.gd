extends Node2D

################################################################################

# ROOMS NODES
onready var rooms = [
	preload("res://Scenes/Maps/Castle/Rooms/Room_01.tscn"), 
	preload("res://Scenes/Maps/Castle/Rooms/Room_02.tscn"),
	preload("res://Scenes/Maps/Castle/Rooms/Room_03.tscn"),
	preload("res://Scenes/Maps/Castle/Rooms/Room_04.tscn")
]

# UTILS
export var current_room_id = 0
var current_room_instance

################################################################################

func handle_door_z_index(player_pos: Vector2) -> void:
	var player_y = player_pos.y
	var door = current_room_instance.get_node("Door")
	var door_y = door.position.y
	
	if (player_y > door_y and door.z_index == 1):
		door.z_index = 0
	elif (player_y < door_y and door.z_index == 0):
		door.z_index = 1

func next_room() -> int:
	if (current_room_id + 1 < rooms.size()):
		current_room_instance.queue_free()
		current_room_id += 1
		current_room_instance = rooms[current_room_id].instance()
		add_child(current_room_instance)
		return 0
	else:
		return -1 # No more room

func _process(_delta: float):
	if (Input.is_action_just_pressed("debug_button")):
		current_room_instance.open_door()

func _ready():
	if (current_room_id < 0 or current_room_id > rooms.size() - 1):
		current_room_id = 0
	
	current_room_instance = rooms[current_room_id].instance()
	add_child(current_room_instance)
