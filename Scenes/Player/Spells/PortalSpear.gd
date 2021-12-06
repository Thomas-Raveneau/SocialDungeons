extends Area2D

################################################################################

# STATS
var SPELL_LEVEL: int = 1
var DAMAGE: float = 5.0

# NODES
onready var animated_sprite = $AnimatedSprite
onready var animated_sprite_down = $AnimatedSpriteDown
onready var animated_sprite_up = $AnimatedSpriteUp
onready var collision_shape = $CollisionShape2D
onready var collision_shape_down = $CollisionShape2DDown
onready var collision_shape_up = $CollisionShape2DUp

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
const offset_y_level_2_up = -40
const offset_y_level_2_down = 40
var direction: Vector2 = Vector2.ZERO

################################################################################

### PRIVATE ###
func _ready() -> void:
	if (SPELL_LEVEL == 0):
		animated_sprite.frame = 5
		animated_sprite.self_modulate.a = 0.7
		animated_sprite_down.visible = false
		animated_sprite_up.visible = false
		collision_shape_down.visible = false
		collision_shape_up.visible = false
	if (SPELL_LEVEL == 1):
		animated_sprite.frame = 5
		animated_sprite_up.frame = 5
		animated_sprite_down.frame = 5
	attack()

func _update_collision_shape_size() -> void:
	var current_frame: int = animated_sprite.frame
	
	if (current_frame == 0):
		collision_shape.disabled = true
		collision_shape.position = Vector2.ZERO
		collision_shape.shape.extents = Vector2.ZERO
		collision_shape_up.disabled = true
		collision_shape_up.position = Vector2.ZERO
		collision_shape_up.shape.extents = Vector2.ZERO
		collision_shape_down.disabled = true
		collision_shape_down.position = Vector2.ZERO
		collision_shape_down.shape.extents = Vector2.ZERO
		return
	elif (current_frame < 3):
		return
	if (current_frame == 3):
		collision_shape.disabled = false
		if (SPELL_LEVEL == 1):
			collision_shape_up.disabled = false
			collision_shape_down.disabled = false
	
	var new_position: Vector2 = frames_size[current_frame][1]
	new_position.x += offset_x
	
	var new_extents: Vector2 = frames_size[current_frame][0]
	new_extents.x = new_extents.x / 2
	
	collision_shape.position = new_position
	collision_shape.shape.extents = new_extents
	if (SPELL_LEVEL == 1):
		collision_shape_up.position = new_position + Vector2(0, offset_y_level_2_up)
		collision_shape_down.position = new_position + Vector2(0, offset_y_level_2_down)
		collision_shape_down.shape.extents = new_extents
		collision_shape_up.shape.extents = new_extents

### PUBLIC ###
func init_params(spear_damage: float, portal_position: Vector2, portal_direction: Vector2) -> void:
	DAMAGE = spear_damage
	position = portal_position
	rotation = portal_direction.angle()

func attack() -> void:
	animated_sprite.frame = 0
	animated_sprite.self_modulate.a = 1
	animated_sprite.play("attack")
	if (SPELL_LEVEL == 1):
		animated_sprite_up.frame = 0
		animated_sprite_up.self_modulate.a = 1
		animated_sprite_up.play("attack")
		animated_sprite_down.frame = 0
		animated_sprite_down.self_modulate.a = 1
		animated_sprite_down.play("attack")

func upgrade() -> void:
	SPELL_LEVEL = 1
	animated_sprite_down.visible = true
	animated_sprite_up.visible = true
	collision_shape_down.visible = true
	collision_shape_up.visible = true

func destroy():
	queue_free()

### SIGNALS ###
func _on_AnimatedSprite_frame_changed():
	_update_collision_shape_size()

func _on_AnimatedSprite_animation_finished():
	destroy()

func _on_PortalSpear_body_entered(body):
	if (get_tree().get_nodes_in_group("mobs").has(body)):
		body.take_damage(DAMAGE, direction, 1, "")
