extends MarginContainer

################################################################################

# SCENE PATHS
const WORLD_SCENE = "res://Scenes/Maps/Main.tscn"
const LEVEL_SCENE = "res://Scenes/Menus/Level_Selector_Menu/Level_Selector.tscn"
const SETTINGS_MENU_SCENE = "res://Scenes/Menus/Settings/Settings.tscn"

# NODES
onready var animation_player: AnimationPlayer = $AnimationPlayer

# UTILS
var MOVING_INTO_SCENE

################################################################################

func _ready():
	animation_player.play("fade_to_normal")

func _on_ContinueButton_pressed():
	print("Continue button pressed")

func _on_PlayButton_pressed():
	MOVING_INTO_SCENE = LEVEL_SCENE
	animation_player.play("fade_to_black")

func _on_SettingsButton_pressed():
	MOVING_INTO_SCENE = SETTINGS_MENU_SCENE

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

### SIGNALS ###
func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "fade_to_black"):
		get_tree().change_scene(MOVING_INTO_SCENE)
