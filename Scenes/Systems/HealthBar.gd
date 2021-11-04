extends Control

const MIN_HEALTH: int = 17
const MAX_HEALTH: int = 50

var currentHealth: int = 0

# Called when the node enters the scene tree for the first time.
onready var player: KinematicBody2D = get_parent().get_parent().get_node("Player")
onready var healthBarOver: TextureProgress = get_node("HealthBarOver")
onready var healthBarUnder: TextureProgress = get_node("HealthBarUnder")
onready var healthBarTween: Tween = get_node("HealthBar/Tween")

func _updateHealthBar(newHealthValue: int) -> void:
	healthBarOver.value = newHealthValue
	var __ = $HealthBarOver/Tween.interpolate_property(healthBarUnder, "value", healthBarUnder.value , newHealthValue, 0.25, Tween.TRANS_SINE , Tween.EASE_OUT, 0.25)
	__ = $HealthBarOver/Tween.start()

func _on_Player_hp_changed(newHp: int) -> void:
	var newHealth: int = int(MAX_HEALTH - MIN_HEALTH) * float(newHp) / MAX_HEALTH + MIN_HEALTH
	print(newHealth)
	_updateHealthBar(newHealth)

#func _process(delta: float) -> void:
#	pass
