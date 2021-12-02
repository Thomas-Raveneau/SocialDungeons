extends "res://Scenes/Mobs/AMonster.gd"

### VARIABLES ###

# MOVEMENT
var velocity : Vector2 = Vector2.ZERO
var knockback : Vector2 = Vector2.ZERO
export var DODGE_SPEED = 200
export var KNOCKBACK_FORCE = 200
var mobs_view : Array

# ACTION
var in_range_of_attack : bool = false
var can_attack : bool = true
var is_attacking  : bool = false
var is_dodging : bool = false
var is_taking_damage  : bool = false

export var ATTACK_COOLDOWN : int = 0
onready var attack_timer : Timer = $AttackTimer

# COLLIDER
onready var hitbox : CollisionShape2D = $Hitbox

# ANIMATION
onready var animation : AnimatedSprite = $Animation

# PROJECTILE
onready var FIREBALL = preload("res://Scenes/Projectile/FireBall.tscn")
onready var spawn_point : Node2D = $SpawnPoint

### PRIVATE METHODS ###

func _ready():
	attack_timer.wait_time = ATTACK_COOLDOWN
	attack_timer.start()
	mobs_view.clear()

func _physics_process(_delta):
	if is_alive:
		_handle_movement()
		_handle_animation()
		_handle_flip()
		_handle_attack()
		_handle_collision()

func _handle_movement():
	velocity = Vector2.ZERO
	if player:
		if !in_range_of_attack:
			velocity = position.direction_to(player.position).normalized() * SPEED
		elif is_dodging:
			velocity = position.direction_to(player.position).normalized() * DODGE_SPEED * -1
		for i in mobs_view:
			velocity = (velocity.normalized() + (position.direction_to(i.position) * -1)).normalized() * SPEED
	if is_taking_damage:
		velocity = knockback.normalized() * KNOCKBACK_FORCE
	velocity = move_and_slide(velocity)

func _handle_attack():
	if in_range_of_attack and can_attack and !is_dodging and !is_taking_damage:
		is_attacking = true
		can_attack = false
		attack_timer.start()
		animation.play("attack")

func _handle_animation():
	if (!is_attacking and !is_taking_damage):
		if (velocity == Vector2(0, 0)):
			animation.play("idle")
		else:
			animation.play("walk")
	elif (is_taking_damage):
		animation.play("hurt")

func _handle_flip():
	if player:
		var orientation = position.direction_to(player.position)
		orientation.x = orientation.x * -1 if is_dodging else orientation.x
		if (orientation.x < 0 and !animation.flip_h):
			animation.flip_h = true
			spawn_point.position.x = spawn_point.position.x * -1
		if (orientation.x > 0 and animation.flip_h):
			animation.flip_h = false
			spawn_point.position.x = spawn_point.position.x * -1

func _handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if hitbox.disabled or !node:
			continue
#		if get_tree().get_nodes_in_group("projectile").has(node.collider):
#			take_damage(node.collider.DAMAGE, node.collider.orientation)
#			node.collider.destroy()

func _handle_death_animation() -> void:
	hitbox.disabled = true
	$DeathSound.play()
	animation.play("death")

func _shoot_fireball():
	var bullet = FIREBALL.instance()
	bullet.position = spawn_point.get_global_position()
	bullet.orientation = player.position - spawn_point.get_global_position()
	get_parent().add_child(bullet)

func _handle_death() -> void:
	queue_free()

func _handle_damage_animation(damage_orientation : Vector2) -> void:
#	$DamageTimer.start()
	animation.play("hurt")
	animation.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
	knockback = Vector2.ZERO
	is_taking_damage = true
	print("BLABLA")

####################### PUBLIC METHODS #########################################

func take_damage(damage_amount : int, damage_orientation : Vector2) -> void:
	health = health - damage_amount
	if (health <= 0):
		is_alive = false
		_handle_death_animation()
	else:
		_handle_damage_animation(damage_orientation)

######################## PRIVATE SIGNALS #######################################

func _on_DodgeArea_body_entered(body):
	if players.has(body):
		is_dodging = true
		in_range_of_attack = true
		player = players[players.find(body)]

func _on_DodgeArea_body_exited(body):
	if player == body:
		is_dodging = false

func _on_RangeArea_body_entered(body):
	if players.has(body):
		in_range_of_attack = true
		player = players[players.find(body)]

func _on_RangeArea_body_exited(body):
	if player == body:
		in_range_of_attack = false

func _on_DetectionArea_body_entered(body):
	if players.has(body):
		player = players[players.find(body)]

func _on_DetectionArea_body_exited(body):
	if player == body:
		player = null

func _on_AttackTimer_timeout():
	can_attack = true

func _on_Animation_animation_finished():
	print("ANIMATION END " + animation.get_animation())
	if animation.get_animation() == "hurt":
		animation.self_modulate = Color(1, 1, 1)
		is_taking_damage = false
		print("END DAMAGE")
	elif animation.get_animation() == "attack":
		is_attacking = false
		_shoot_fireball()
	elif animation.get_animation() == "death":
		is_attacking = false
		_handle_death()

func _on_DamageTimer_timeout() -> void:
	pass
	animation.self_modulate = Color(1, 1, 1)
	is_taking_damage = false

func _on_UnSplitArea_body_entered(body):
	if get_tree().get_nodes_in_group("mobs").has(body):
		mobs_view.push_back(body)

func _on_UnSplitArea_body_exited(body):
	if mobs_view.has(body):
		mobs_view.erase(body)
