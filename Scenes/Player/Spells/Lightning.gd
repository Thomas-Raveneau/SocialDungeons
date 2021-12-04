extends Area2D

################################################################################

# STATS
var SPELL_LEVEL: int = 1
var DAMAGE: float = 5.0

# NODES
onready var animated_sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D

# UTILS
var orientation : Vector2 = Vector2.ZERO

################################################################################

### PRIVATE ###
func _ready():
	if (SPELL_LEVEL == 1):
		animated_sprite.self_modulate = Color(246/255.0, 26/255.0, 35/255.0)
		DAMAGE *= 2
	animated_sprite.play("attack")

func _physics_process(_delta: float) -> void:
	pass

### PUBLIC ###
func init_params(lightning_damage: float, lightning_position: Vector2, lightning_direction: Vector2) -> void:
	DAMAGE = lightning_damage
	position = lightning_position
	orientation = lightning_direction
	rotation = lightning_direction.angle()

func upgrade() -> void:
	SPELL_LEVEL = 1

func destroy() -> void :
	queue_free()

### SIGNALS ###
func _on_AnimatedSprite_animation_finished():
	destroy()

func _on_Lightning_body_entered(body):
	if (get_tree().get_nodes_in_group("mobs").has(body)):
		body.take_damage(DAMAGE, Vector2.ZERO, 1, '')
