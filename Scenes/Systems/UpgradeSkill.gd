extends Node2D

# Called when the node enters the scene tree for the first time.
onready var animation: AnimationPlayer = get_parent().get_parent().get_node("AnimationPlayer")

func _ready() -> void:
	pass # Replace with function body.


func _on_Castle_room_cleared() -> void:
	print("Castle room cleared")
	get_child(1).get_child(0).visible = true
	get_child(0).get_child(0).visible = true 
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	
#		var state_pause = not get_tree().paused
#	get_tree().paused = state_pause
#	visible = state_pause
	pass # Replace with function body.


func _on_UpgradeSpell1_pressed() -> void:
	print('Spell 1 has been upgraded')
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	get_child(1).get_child(0).visible = state_pause
	get_child(0).get_child(0).visible = state_pause
	animation.play("fade_to_normal_start")

	pass # Replace with function body.

func _on_UpgradeSpell2_pressed() -> void:
	print('Spell 2 has been upgraded')
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	get_child(1).get_child(0).visible = state_pause
	get_child(0).get_child(0).visible = state_pause
	animation.play("fade_to_normal_start")

	pass # Replace with function body.

func _on_UpgradeSpell3_pressed() -> void:
	print('Spell 3 has been upgraded')
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	get_child(1).get_child(0).visible = state_pause
	get_child(0).get_child(0).visible = state_pause
	animation.play("fade_to_normal_start")

	pass # Replace with function body.

func _on_UpgradeSpell4_pressed() -> void:
	print('Spell 4 has been upgraded')
	var state_pause = not get_tree().paused
	get_tree().paused = state_pause
	get_child(1).get_child(0).visible = state_pause
	get_child(0).get_child(0).visible = state_pause
	animation.play("fade_to_normal_start")

	pass # Replace with function body.
