extends KinematicBody2D

################################################################################

# STATS
var SPELL_LEVEL: int = 1
var SPEED: float = 0.0
var DAMAGE: float = 0.0
var ACCELERATION: float = 1.0

# UTILS
var orientation: Vector2 = Vector2.ZERO
var attack_point: Vector2 = Vector2.ZERO
var direction_state: String = "toward_target"
var touch_target : Array

################################################################################

### PRIVATE ###
func _physics_process(_delta: float) -> void:
	_handle_spell_levels()

func _get_dir_to_player() -> Vector2:
	return (get_parent().get_player_pos() - global_position).normalized()

func _get_distance_to_player() -> float:
	return (position.distance_to(get_parent().get_player_pos()))

func _handle_spell_levels() -> void:
	if (SPELL_LEVEL == 0):
		_handle_spell_level_1()
	if (SPELL_LEVEL == 1):
		_handle_spell_level_2()

func _handle_spell_level_1() -> void:
	_handle_movement_level_1()
	_handle_collision_level_1()

func _handle_movement_level_1() -> void:
	rotate(0.3)
	move_and_slide(orientation * SPEED * 100)

func _handle_collision_level_1() -> void:
	var slide_count = get_slide_count()
	
	for i in slide_count:
		var node = get_slide_collision(i)
		if get_tree().get_nodes_in_group("wall").has(node.collider):
			destroy()
		elif get_tree().get_nodes_in_group("mobs").has(node.collider) and !touch_target.has(node.collider):
			node.collider.take_damage(DAMAGE, position - node.collider.position)
			touch_target.push_back(node.collider)

func _handle_spell_level_2() -> void:
	_handle_movement_level_2()
	_handle_collision_level_2()
	_handle_destroy_level_2()

func _handle_movement_level_2() -> void:
	var distance_to_point: float = global_position.distance_to(attack_point)
	
	if (direction_state == "toward_player"):
		orientation = _get_dir_to_player()
	
	if (distance_to_point < 250 and direction_state == "toward_target"):
		var weight = (1 / distance_to_point) * 50
		
		ACCELERATION = lerp(ACCELERATION, 0.5, weight)
		move_and_slide(orientation * (SPEED * ACCELERATION) * 100)
	elif (distance_to_point < 250 and direction_state == "toward_player"):
		var weight = distance_to_point * 2
		
		ACCELERATION = lerp(ACCELERATION, 1, 1)
		move_and_slide(orientation * (SPEED * ACCELERATION) * 100)
	else:
		move_and_slide(orientation * SPEED * 100)
	
	rotate(0.3)
	
	if (distance_to_point <= 10 and direction_state == "toward_target"):
		direction_state = "toward_player"
		orientation = _get_dir_to_player()

func _handle_collision_level_2() -> void:
	var slide_count = get_slide_count()

	for i in slide_count:
		var node = get_slide_collision(i)
		
		if get_tree().get_nodes_in_group("wall").has(node.collider):
			destroy()
		elif get_tree().get_nodes_in_group("player").has(node.collider) and direction_state == "toward_player":
			destroy()
		elif get_tree().get_nodes_in_group("mobs").has(node.collider) and !touch_target.has(node.collider):
			node.collider.take_damage(DAMAGE, position - node.collider.position)
			touch_target.push_back(node.collider)
			destroy()

func _handle_destroy_level_2() -> void:
	if _get_distance_to_player() < 50.0 and direction_state == "toward_player":
		destroy()

### PUBLIC ###
func init_params(axe_damage: float, axe_speed: float, attack_pos: Vector2, axe_pos: Vector2) -> void:
	var axe_dir: Vector2 = (attack_pos - axe_pos).normalized()
	
	DAMAGE = axe_damage
	SPEED = axe_speed
	orientation = axe_dir
	attack_point = attack_pos
	position = axe_pos + (axe_dir * 100)
	rotation = axe_dir.angle()

func destroy() -> void:
	queue_free()

### SIGNALS ###
func _on_VisibilityNotifier2D_screen_exited():
	destroy()
