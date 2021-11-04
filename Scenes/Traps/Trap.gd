extends Area2D

onready var Player = preload("res://Scenes/Player/Player.tscn")

func _ready():
	pass # Replace with function body.

func _process(delta):
	var player = Player.instance()
	if (self.overlaps_area(player) == true):
		$AnimatedSprite.play()


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.set_frame(0)
	$AnimatedSprite.stop() # Replace with function body.
