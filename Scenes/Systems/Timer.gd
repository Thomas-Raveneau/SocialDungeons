extends RichTextLabel

var timer_state: bool = false
var time: float = 0

func _ready():
	timer_state = true

func _process(delta):
	if (timer_state == true):
		time += delta
		var minutes: int = fmod(time, 60 * 60) / 60
		var seconds: int = fmod(time, 60)
		var milliseconds: int = fmod(time, 1)* 1000

		text = "%02d : %02d : %03d" % [minutes, seconds, milliseconds]
