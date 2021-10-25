extends Node2D

onready var screen_size: Vector2 = get_viewport_rect().size

func _ready():
	print(screen_size)
