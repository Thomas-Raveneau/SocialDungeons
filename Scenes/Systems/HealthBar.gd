extends Control


var currentHealth: int = 0
var maxHpPool: int = 100

# Called when the node enters the scene tree for the first time.
onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var healthBar: ProgressBar = get_child(0)
onready var healthBarTween: Tween = get_child(0).get_node("Tween")

func _ready() -> void:
	maxHpPool = player.HEALTH
	updateHealthBar(2)
	pass # Replace with function body.

func updateHealthBar(newHealthValue: int) -> void:
	var __ = healthBarTween.interpolate_property(healthBar, "newHealthValue", healthBar.value, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = healthBarTween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
