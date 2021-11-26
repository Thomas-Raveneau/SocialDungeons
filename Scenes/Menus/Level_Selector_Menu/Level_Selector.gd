extends Control

################################################################################

# SCENES
const MAIN_MENU_SCENE = "res://Scenes/Menus/Main/Main.tscn"
const LEVEL1_SCENE = "res://Scenes/Maps/Main.tscn"

# NODES
onready var animation_player: AnimationPlayer = $AnimationPlayer

# UTILS
var MOVING_INTO_SCENE

################################################################################

func _ready() -> void:
	animation_player.play("fade_to_normal")

func _on_Level1Selector_pressed() -> void:
	print("Selected Level 1")
	animation_player.play("fade_to_black")
	MOVING_INTO_SCENE = LEVEL1_SCENE

func _on_Level2Selector_pressed() -> void:
	print("Selected Level 2")

func _on_Level3Selector_pressed() -> void:
	print("Selected Level 3")

func _on_ReturnButton_pressed() -> void:
	get_tree().change_scene(MAIN_MENU_SCENE)

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "fade_to_black"):
		get_tree().change_scene(MOVING_INTO_SCENE)
