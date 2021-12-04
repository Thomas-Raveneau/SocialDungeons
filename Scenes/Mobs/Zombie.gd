extends "res://Scenes/Mobs/AMonster.gd"

########################### VARIABLES ##########################################

# COLLIDER

# ATTACK
var in_range_of_attack : bool = false
var can_attack : bool = true
var is_attacking : bool = false

# DASH
export var DASH_SPEED : float = 500
export var DASH_COOLDOWN : int = 5

var dash_vector : Vector2 = Vector2.ZERO
var is_taking_damage : bool = false
var is_dashing : bool = false
var knockback: Vector2 = Vector2.ZERO
var DASH_DURATION: float = 1.0
var TAUNT_DURATION: float = 0.5


# NODES

onready var dash_timer : Timer = $DashTimer
onready var hitbox : CollisionShape2D = $Hitbox
onready var dash_duration_timer = $DashDuration
onready var taunt_duration_timer = $TauntDuration
onready var animation : AnimatedSprite = $Animation
onready var damage_duration_timer: Timer = $DamageDuration

######################## PRIVATE METHODS #######################################

func _ready():
	._ready()
	dash_timer.wait_time = DASH_COOLDOWN
	dash_duration_timer.wait_time = DASH_DURATION
	taunt_duration_timer.wait_time = TAUNT_DURATION
	CURRENT_WEIGHT_CLASS = WEIGHT_CLASS.HEAVY

func _physics_process(_delta) -> void:
	if is_alive:
		_handle_movement()
		_handle_attack()
		_handle_animation()
		_handle_flip()
		_handle_collision()

func _handle_movement() -> void:
	velocity = Vector2.ZERO
	if player and !is_attacking:
		velocity = position.direction_to(player.position) * SPEED
	elif is_dashing:
		velocity = dash_vector * DASH_SPEED
	elif is_taking_damage:
		velocity = (position.direction_to(player.position).normalized() * knockback.normalized() * get_knockback_multiplier()) * -1
	velocity = move_and_slide(velocity)

func _handle_attack() -> void:
	if in_range_of_attack and can_attack:
		can_attack = false
		is_attacking = true
		dash_vector = position.direction_to(player.position).normalized()
		animation.play("idle")
		taunt_duration_timer.start()

func _handle_flip() -> void:
	if player and !is_attacking:
		if (velocity.x < 0 and !animation.flip_h):
			animation.flip_h = true
		if (velocity.x > 0 and animation.flip_h):
			animation.flip_h = false

func _handle_animation() -> void:
	if (!is_attacking):
		if (velocity == Vector2(0, 0)):
			animation.play("idle")
		else:
			animation.play("run")

func _handle_death_animation() -> void:
	animation.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
	_handle_death()

func _handle_collision() -> void:
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if hitbox.disabled or !node:
			continue
		if get_tree().get_nodes_in_group("player").has(node.collider):
			_handle_hit_attack(node)
		if get_tree().get_nodes_in_group("wall").has(node.collider):
			is_dashing = false

func _handle_hit_attack(node):
	if is_dashing:
		node.collider.damage(DAMAGE, position - node.collider.position)

######################### PUBLIC METHODS #######################################

func _handle_damage_animation(damage_orientation : Vector2, knockback_force : int, spell_state : String) -> void:
	damage_duration_timer.start()
	if (spell_state == 'toward_player'):
		knockback = Vector2.ZERO
	else:
		knockback = get_knockback_multiplier() * knockback_force
	animation.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
	is_taking_damage = true

#func take_damage(damage_amount : int, damage_orientation : Vector2, knockback_force : int, spell_state : String) -> void:
#	if !is_dashing:
#		.take_damage(damage_amount, damage_orientation, knockback_force, spell_state)
#		animation.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
#		damage_duration_timer.start()

func take_damage(damage_amount : int, damage_orientation : Vector2, knockback_force : int, spell_state : String) -> void:
	if !is_dashing:
		health = health - damage_amount
		if (health <= 0):
			is_alive = false
			_handle_death_animation()
		else:
			_handle_damage_animation(damage_orientation, knockback_force, spell_state)

######################### PRIVATE SIGNALS ######################################

func _on_DetectionArea_body_entered(body) -> void:
	if players.has(body):
		player = players[players.find(body)]

func _on_DetectionArea_body_exited(body) -> void:
	if player == body:
		player = null

func _on_RangeArea_body_entered(body) -> void:
	if player == body:
		in_range_of_attack = true

func _on_RangeArea_body_exited(body) -> void:
	if player == body:
		in_range_of_attack = false

func _on_DashTimer_timeout() -> void:
	can_attack = true

func _on_DashDuration_timeout():
	is_dashing = false
	is_attacking = false
	dash_timer.start()

func _on_TauntDuration_timeout():
	is_dashing = true
	animation.play("run")
	dash_duration_timer.start()

func _on_DamageDuration_timeout():
	animation.self_modulate = Color(1, 1, 1)
