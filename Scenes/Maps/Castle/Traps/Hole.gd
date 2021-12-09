extends Area2D

# UTILS
var player: Node = null
var player_size: Vector2 = Vector2.ZERO

const HOLE_RANGE_X: int = 20
const HOLE_RANGE_Y: int = 15

func _ready():
	pass

func _physics_process(_delta):
	if (player):
		is_player_inside()

func is_player_inside() -> void:
	if (player.position.y + player_size.y - position.y < HOLE_RANGE_Y and
		abs(player.position.x - position.x) - player_size.x < HOLE_RANGE_X):
		player.fall(self.position)
		player = null

func _on_Hole_body_entered(body):
	if (get_tree().get_nodes_in_group("player").has(body)):
		player = body
		player_size = player.skin.get_sprite_frames().get_frame("idle", 0).get_size()

func _on_Hole_body_exited(body):
	if (get_tree().get_nodes_in_group("player").has(body)):
		player = null
