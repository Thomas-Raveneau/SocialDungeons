extends Control

const MAIN_MENU_SCENE = "res://Scenes/Menus/Main/Main.tscn"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_pause"):
		var state_pause = not get_tree().paused
		get_tree().paused = state_pause
		visible = state_pause
		
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_ResumePauseButton_pressed() -> void:
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	visible = state_pause
	pass # Replace with function body.


func _on_QuitPauseButton_pressed() -> void:
	get_tree().change_scene(MAIN_MENU_SCENE)
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	visible = state_pause
	pass # Replace with function body.
