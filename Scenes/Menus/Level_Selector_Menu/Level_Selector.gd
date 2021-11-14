extends Control


const MAIN_MENU_SCENE = "res://Scenes/Menus/Main/Main.tscn"
const LEVEL1_SCENE = "res://Scenes/Maps/Main.tscn"
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Level1Selector_pressed() -> void:
	print("Selected Level 1")
	get_tree().change_scene(LEVEL1_SCENE)
	pass # Replace with function body.


func _on_Level2Selector_pressed() -> void:
	print("Selected Level 2")
	pass # Replace with function body.


func _on_Level3Selector_pressed() -> void:
	print("Selected Level 3")
	pass # Replace with function body.


func _on_ReturnButton_pressed() -> void:
	get_tree().change_scene(MAIN_MENU_SCENE)
	pass # Replace with function body.
