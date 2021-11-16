extends Area2D

################################################################################

# NODES

onready var animated_sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D

# UTILS
const frames_size = [
	[Vector2.ZERO, Vector2.ZERO], # [COLLISION_SIZE, COLLISION_POSITION]
	[Vector2.ZERO, Vector2.ZERO],
	[Vector2.ZERO, Vector2.ZERO],
	[Vector2(15, 17), Vector2(-44, 0)],
	[Vector2(30, 17), Vector2(-36, 0)],
	[Vector2(45, 17), Vector2(-27, 0)],
	[Vector2(110, 17), Vector2(5, 0)]
]

const offset_x: int = 59

################################################################################

### PRIVATE ###
func _ready() -> void:
	animated_sprite.frame = 5
	animated_sprite.self_modulate.a = 0.7

func _update_collision_shape_size() -> void:
	var current_frame: int = animated_sprite.frame
	
	if (current_frame == 0):
		collision_shape.disabled = true
		collision_shape.position = Vector2.ZERO
		collision_shape.shape.extents = Vector2.ZERO
		return
	elif (current_frame < 3):
		return
	if (current_frame == 3):
		collision_shape.disabled = false
	
	var new_position: Vector2 = frames_size[current_frame][1]
	new_position.x += offset_x
	collision_shape.position = new_position
	
	var new_extents: Vector2 = frames_size[current_frame][0]
	new_extents.x = new_extents.x / 2
	collision_shape.shape.extents = new_extents

### PUBLIC ###
func attack() -> void:
	animated_sprite.frame = 0
	animated_sprite.self_modulate.a = 1
	animated_sprite.play("attack")

func destroy():
	queue_free()

### SIGNALS ###
func _on_AnimatedSprite_frame_changed():
	_update_collision_shape_size()

func _on_AnimatedSprite_animation_finished():
	destroy()
