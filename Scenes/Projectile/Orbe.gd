extends "res://Scenes/Projectile/AProjectile.gd"


onready var skin : AnimatedSprite = $AnimatedSprite



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	if (skin.get_animation() == "death"):
		queue_free()
