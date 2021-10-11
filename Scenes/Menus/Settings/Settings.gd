extends MarginContainer

const MAIN_MENU_SCENE = "res://Scenes/Menus/Main/Main.tscn"

func _ready():
	pass



func _on_BackHomeButton_pressed():
	get_tree().change_scene(MAIN_MENU_SCENE)
