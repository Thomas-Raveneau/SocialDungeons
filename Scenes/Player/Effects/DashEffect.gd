extends KinematicBody2D

### VARIABLES ###

onready var animation : AnimatedSprite = $AnimatedSprite

### PRIVATE METHODS ###

func _ready():
	animation.play("dash_effect")

func _on_AnimatedSprite_animation_finished():
	queue_free()

