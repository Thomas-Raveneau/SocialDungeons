extends Control

const MIN_HEALTH: int = 17
const MAX_HEALTH: int = 83

var currentHealth: int = 0 
var maxHpPool: int = 83

# Called when the node enters the scene tree for the first time.
onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var healthBar: TextureProgress = get_node("HealthBar")
onready var healthBarTween: Tween = get_node("HealthBar/Tween")

func _ready() -> void:
	maxHpPool = player.HEALTH
	print(maxHpPool)
	_updateHealthBar(40)

func _updateHealthBar(newHealthValue: int) -> void:
	healthBar.value = newHealthValue
	var __ = healthBarTween.interpolate_property($healthBar, "value", newHealthValue, 0.25, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = healthBarTween.start()

func _on_Player_hp_changed(newHp: int) -> void:
	var newHealth: int = int(MAX_HEALTH - MIN_HEALTH) * float(newHp) / MAX_HEALTH + MIN_HEALTH
	print(newHealth)
	_updateHealthBar(newHealth)
#func _process(delta: float) -> void:
#	pass
