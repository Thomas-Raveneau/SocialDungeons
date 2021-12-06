extends Control

onready var animation_player: AnimationPlayer = $AnimationPlayer

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Player_killed() -> void:
	get_node("CanvasLayer/RichTextLabel").visible = true
	animation_player.play("fade_to_black")
	pass # Replace with function body.
