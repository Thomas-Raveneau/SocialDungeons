extends Node2D

################################################################################

# NODES
onready var player_spawn = $PlayerSpawn
onready var player = $Player
onready var castle = $Castle
onready var player_visibility = $Player/VisibilityNotifier2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var counting_animation_player: AnimationPlayer = $StartCountingAnimation
onready var game_timer = $Timer

# UTILS
var going_next_room: bool = false
var in_next_room: bool = false

################################################################################

### PRIVATE ###
func _ready() -> void:
	animation_player.play("fade_to_normal_start")
	counting_animation_player.play("start_count")
	set_player_to_spawn()

func _process(_delta: float) -> void:
	handle_player_room_exit()

### PUBLIC ###
func set_player_to_spawn() -> void:
	player.position = player_spawn.position

func handle_player_room_exit() -> void:
	castle.handle_door_z_index(player.position)
	
	if (!player_visibility.is_on_screen() and going_next_room == false):
		if (!in_next_room):
			animation_player.play("fade_to_black")
			going_next_room = true
		else:
			animation_player.play("fade_to_normal")
			in_next_room = false

func get_player():
	return player

func get_player_pos() -> Vector2:
	return player.position

### SIGNALS ###
func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "fade_to_black" and going_next_room == true):
		set_player_to_spawn()
		castle.next_room()
		going_next_room = false
		in_next_room = true

func _on_StartCountingAnimation_animation_finished(anim_name):
	game_timer.start()
