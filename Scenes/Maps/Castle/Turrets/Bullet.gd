extends RigidBody2D

func _process(_delta):
	if (int(self.rotation) == 0):
		self.position.x += 5
	elif (int(self.rotation) == 180):
		self.position.x -= 5
	elif (int(self.rotation) == 90):
		self.position.y -= 5
	else:
		self.position.y += 5

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
