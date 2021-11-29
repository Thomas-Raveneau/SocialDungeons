extends HBoxContainer

signal autohit(cooldown)
signal first_spell(cooldown)
signal second_spell(cooldown)
signal ultimate(cooldown)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_spell(spellNumber: int, spellCooldown: float) -> void:
	if spellNumber == 1:
		emit_signal("autohit", spellCooldown);
	elif spellNumber == 2:
		emit_signal("first_spell", spellCooldown);
	elif spellNumber == 3:
		emit_signal("second_spell", spellCooldown);
	else:
		emit_signal("ultimate", spellCooldown);
