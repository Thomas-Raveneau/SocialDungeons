extends Area2D

### VARIABLE ###

# STATS
export var DAMAGE : float = 10

# UTILS
var orientation : Vector2 = Vector2.ZERO
var target_touched : Array
var bodies : Array

# NODE
onready var skin : AnimatedSprite = $AnimatedSprite

### PRIVATE METHODS ###

func _ready():
	_handle_flip()
	rotation = orientation.angle()
	skin.play("attack")

func _handle_flip():
	if (orientation.x < 0 and !skin.flip_v):
		skin.flip_v = true
	if (orientation.x > 0 and skin.flip_v):
		skin.flip_v = false

func _handle_attack() -> void:
	for body in bodies:
		body.damage(DAMAGE, orientation)

### PUBLIC METHODS ###

func destroy() -> void:
	queue_free()

### PRIVATE SIGNALS ###

func _on_AnimatedSprite_frame_changed():
	if skin.get_frame() == 5:
		_handle_attack()

func _on_AnimatedSprite_animation_finished():
	destroy()

func _on_Sword_body_entered(body):
	if get_tree().get_nodes_in_group("player").has(body):
		bodies.push_back(body)

func _on_Sword_body_exited(body):
	if (bodies.has(body)):
		bodies.erase(body)
