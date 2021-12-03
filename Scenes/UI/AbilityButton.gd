extends TextureButton

onready var time_label = $Counter/Value

export var cooldown = 1.0


func _ready():
	time_label.hide()
	$Sweep.value = 0
	$Sweep.texture_progress = texture_normal
	set_process(false)


func _process(delta):
	time_label.text = "%3.1f" % $Timer.time_left
	$Sweep.value = int(($Timer.time_left / cooldown) * 100)


func _on_Timer_timeout():
	$Sweep.value = 0
	disabled = false
	time_label.hide()
	set_process(false)

func _on_spell(spellCooldown: float):
	disabled = true
	set_process(true)
	$Timer.wait_time = spellCooldown
	cooldown = spellCooldown
	$Timer.start()
	time_label.show()
