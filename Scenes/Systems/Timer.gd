extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer_state: bool = false
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_state = true

func _process(delta):
	if (timer_state == true):
		time += delta
		var minutes: int = fmod(time, 60 * 60) / 60
		var seconds: int = fmod(time, 60)
		var milliseconds: int = fmod(time, 1)* 1000

		text = "%02d : %02d : %03d" % [minutes, seconds, milliseconds]
		pass
		
#		set_text(str(minutes) + ':' + str(seconds) + ':' + str(milliseconds))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
