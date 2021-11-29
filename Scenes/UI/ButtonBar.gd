extends HBoxContainer

signal autohit()
signal first_spell()
signal second_spell()
signal ultimate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_spell(spellNumber: int) -> void:
	if spellNumber == 1:
		emit_signal("autohit");
	elif spellNumber == 2:
		emit_signal("first_spell");
	elif spellNumber == 3:
		emit_signal("second_spell");
	else:
		emit_signal("ultimate");
