extends HBoxContainer

signal autohit(cooldown)
signal first_spell(cooldown)
signal second_spell(cooldown)
signal ultimate(cooldown)

export (float) var autohit_shader_range = 0.0;
export (float) var first_shader_range = 0.0;
export (float) var second_shader_range = 0.0;
export (float) var ultimate_shader_range = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_autohit_shader_range():
	$AutohitFlash.material.set_shader_param("range", autohit_shader_range);

func animate_autohit():
	$AnimationAutohitFlash.play("AutohitFlash");

func update_first_shader_range():
	$FirstSpellFlash.material.set_shader_param("range", first_shader_range);

func animate():
	$AnimationSpellFlash.play("spellFlash");
	
func update_second_shader_range():
	$SecondSpellFlash.material.set_shader_param("range", second_shader_range);

func animate_second_spell():
	$AnimationSecondSpellFlash.play("SecondSpellFlash");

func update_ultimate_shader_range():
	$UltimateFlash.material.set_shader_param("range", ultimate_shader_range);

func animate_ultimate():
	$AnimationUltimateFlash.play("UltimateFlash");

func _on_Player_spell(spellNumber: int, spellCooldown: float) -> void:
	if spellNumber == 1:
		if ($AutohitButton/Timer.time_left > 0):
			animate_autohit();
		else:	
			emit_signal("autohit", spellCooldown);
	elif spellNumber == 2:
		if ($FirstSpellButton/Timer.time_left > 0):
			animate();
		else:
			emit_signal("first_spell", spellCooldown);
	elif spellNumber == 3:
		if ($SecondSpellButton/Timer.time_left > 0):
			animate_second_spell();
		else:
			emit_signal("second_spell", spellCooldown);
	else:
		if ($UltimateButton/Timer.time_left > 0):
			animate_ultimate();
		else:
			emit_signal("ultimate", spellCooldown);
