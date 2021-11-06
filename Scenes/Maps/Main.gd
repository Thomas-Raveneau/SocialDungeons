extends Node2D

################################################################################

# NODES
onready var player_spawn = $PlayerSpawn
onready var player = $Player
onready var castle = $Castle
onready var player_visibility = $Player/VisibilityNotifier2D

################################################################################

func _ready() -> void:
	set_player_to_spawn()

func _process(_delta: float) -> void:
	handle_player_room_exit()

func set_player_to_spawn() -> void:
	player.position = player_spawn.position

func handle_player_room_exit() -> void:
	castle.handle_door_z_index(player.position)
	
	if (!player_visibility.is_on_screen()):
		castle.next_room()
		set_player_to_spawn()
