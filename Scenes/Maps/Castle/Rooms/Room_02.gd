extends Node2D

onready var door_animation = $Door/OpeningAnimation
onready var door_closed_collision = $Door/ClosedCollision
onready var door_opened_collision_left = $Door/OpenedCollisionLeft
onready var door_opened_collision_right = $Door/OpenedCollisionRight

func _ready():
	door_opened_collision_left.disabled = true
	door_opened_collision_right.disabled = true

func open_door():
	door_animation.play("open")
	door_closed_collision.disabled = true
	door_opened_collision_left.disabled = false
	door_opened_collision_right.disabled = false

func close_door():
	door_animation.stop()
	door_animation.frame = 0
	door_closed_collision.disabled = false
	door_opened_collision_left.disabled = true
	door_opened_collision_right.disabled = true
