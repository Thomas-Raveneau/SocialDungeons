extends TextureButton

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (Save.currentHighScore):
		get_node("Label").set_text('Current highscore for Dungeon1: ' + str(Save.currentHighScore))
	else:
		get_node("Label").set_text('No highscore for Dungeon1 yet')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
