extends Area2D

onready var Bullet = preload("res://Scenes/Turrets/Bullet.tscn")

func _ready():
	$ShootTimer.start()

func _on_Timer_timeout():
	var bullet = Bullet.instance()
	add_child(bullet)
	var txture = $TurretSprite.frames.get_frame("default", 0)
	bullet.rotation = $TurretSprite.rotation
	if (int($TurretSprite.rotation_degrees) == 0):
		bullet.position = Vector2(txture.get_size().x / 2, 0)
	elif (int($TurretSprite.rotation_degrees) == 180):
		bullet.position = Vector2(-txture.get_size().x / 2 , 0)
	elif (int($TurretSprite.rotation_degrees) == 90):
		bullet.position = Vector2(0 , txture.get_size().y / 2)
	else:
		bullet.position = Vector2(0 , -txture.get_size().y / 2)
