extends Particles2D

func _ready():
	yield(get_tree().create_timer(self.lifetime), "timeout")
	queue_free()
