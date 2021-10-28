extends MarginContainer

const WORLD_SCENE = "res://Scenes/Maps/Main.tscn"
const SETTINGS_MENU_SCENE = "res://Scenes/Menus/Settings/Settings.tscn"

func _ready():
	pass

func _on_ContinueButton_pressed():
	print("Continue button pressed")

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/Maps/Main.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene(SETTINGS_MENU_SCENE)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

