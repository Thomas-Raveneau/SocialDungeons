extends Area2D

# STATS
export var DAMAGE: float = 15

# UTILS
var player_node: Node
var is_hole_active: bool = true

func _ready():
	pass

func _on_Hole_body_entered(body):
	if (get_tree().get_nodes_in_group("player").has(body) and is_hole_active):
		body.damage(DAMAGE, Vector2.ZERO)
		is_hole_active = false
		$FallCooldown.start()

func _on_FallCooldown_timeout():
	is_hole_active = true
