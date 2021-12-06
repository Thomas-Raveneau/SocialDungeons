extends Node2D

################################################################################

onready var animation: AnimationPlayer = get_parent().get_parent().get_node("AnimationPlayer")

signal on_skill_updrade(skill_to_upgrade)

################################################################################


func _on_Castle_room_cleared() -> void:
	get_child(1).get_child(0).visible = true
	get_child(0).get_child(0).visible = true 
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause

func _upgrade_transition() -> void:
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	get_child(1).get_child(0).visible = state_pause
	get_child(0).get_child(0).visible = state_pause
	animation.play("fade_to_normal_start")

func _on_UpgradeSpell1_pressed() -> void:
	emit_signal("on_skill_updrade", "basic_attack")
	_upgrade_transition()

func _on_UpgradeSpell2_pressed() -> void:
	emit_signal("on_skill_updrade", "portal_spear")	
	_upgrade_transition()

func _on_UpgradeSpell3_pressed() -> void:
	emit_signal("on_skill_updrade", "lightning")	
	_upgrade_transition()

func _on_UpgradeSpell4_pressed() -> void:
	_upgrade_transition()
