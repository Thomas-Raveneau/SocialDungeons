extends HBoxContainer

signal autohit(cooldown)
signal first_spell(cooldown)
signal second_spell(cooldown)
signal ultimate(cooldown)

export (float) var shader_range = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_shader_range():
	$FirstSpellFlash.material.set_shader_param("range", shader_range);

func animate():
	$AnimationPlayer.play("spellFlash");

func _on_Player_spell(spellNumber: int, spellCooldown: float) -> void:
	if spellNumber == 1:
		emit_signal("autohit", spellCooldown);
	elif spellNumber == 2:
		animate();
		#emit_signal("first_spell", spellCooldown);
	elif spellNumber == 3:
		emit_signal("second_spell", spellCooldown);
	else:
		emit_signal("ultimate", spellCooldown);
