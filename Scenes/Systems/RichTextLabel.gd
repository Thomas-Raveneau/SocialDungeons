extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var started: bool = false
var minutes: int = 0
var seconds: int = 0
var milliseconds: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text(str(minutes) + ':' + str(seconds) + ':' + str(milliseconds))

func _process(delta):
	seconds += delta
	seconds = fmod(seconds, delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
