extends Control

onready var animation_player: AnimationPlayer = $AnimationPlayer

const MAIN_MENU_SCENE = "res://Scenes/Menus/Main/Main.tscn"
const LEVEL1_SCENE = "res://Scenes/Maps/Main.tscn"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("CanvasLayer/ButtonContainer/RetryButton").connect("pressed", self, '_on_ButtonRetry_pressed')
	get_node("CanvasLayer/ButtonContainer/QuitButton").connect("pressed", self, '_on_ButtonQuit_pressed2')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_ButtonRetry_pressed() -> void:
	get_parent().get_parent().get_node("Castle").reset_rooms()
	get_tree().change_scene(LEVEL1_SCENE)
	print('Button Pressed')

func _on_ButtonQuit_pressed2() -> void:
	get_tree().change_scene(MAIN_MENU_SCENE)
	print('Button Pressed')


func _on_Player_killed() -> void:
	get_node("CanvasLayer/RichTextLabel").visible = true
	get_node("CanvasLayer/ButtonContainer").visible = true
	animation_player.play("fade_to_black")
	pass # Replace with function body.
