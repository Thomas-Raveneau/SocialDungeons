extends "res://Scenes/Mobs/AMonster.gd"

######################### VARIABLES ############################################

# MOVEMENT
var mobs_view : Array

# UTILS
var knockback : Vector2 = Vector2.ZERO
var can_attack : bool = true
var is_attacking : bool = false
var is_taking_damage : bool = false

# TIMER
export var ATTACK_COOLDOWN : int = 0

# NODE
onready var skin : AnimatedSprite = $AnimationSprite
onready var hitbox : CollisionShape2D = $Hitbox
onready var attack_timer : Timer = $AttackTimer
onready var do_attack_timer : Timer = $DoAttackTimer
onready var damage_timer : Timer = $DamageTimer

# SCENE
var SWORD = preload("res://Scenes/Projectile/Sword.tscn")

######################### PRIVATE METHODS ######################################

func _ready():
	._ready()
	attack_timer.wait_time = ATTACK_COOLDOWN

func _physics_process(_delta):
	if is_alive:
		_handle_movement()
		_handle_flip()
		_handle_animation()
		_handle_collision()

func _handle_movement():
	velocity = Vector2.ZERO
	if player and !is_taking_damage and !is_attacking:
		velocity = position.direction_to(player.position).normalized() * SPEED
	elif is_taking_damage:
		velocity = knockback.normalized() * KNOCKBACK_FORCE
	for i in mobs_view:
		velocity = (velocity.normalized() + (position.direction_to(i.position) * -1)).normalized() * SPEED
	velocity = move_and_slide(velocity)

func _handle_flip():
	if (velocity.x < 0 and !skin.flip_h):
		skin.flip_h = true
	if (velocity.x > 0 and skin.flip_h):
		skin.flip_h = false

func _handle_animation():
	if is_taking_damage:
		skin.play('hit')
	elif velocity == Vector2.ZERO:
		skin.play('idle')
	else:
		skin.play('run')

func _handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if hitbox.disabled or !node:
			continue
		if get_tree().get_nodes_in_group("player").has(node.collider) and can_attack:
			_handle_attack(node)
#		if get_tree().get_nodes_in_group("projectile").has(node.collider):
#			$DamageTimer.start()
#			skin.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
#			take_damage(node.collider.DAMAGE, node.collider.orientation)

func _handle_attack(node):
	if can_attack and !is_taking_damage:
		var sword = SWORD.instance()
		sword.position = position + ((player.position - position).normalized() * 20)
		sword.orientation = player.position - position
		get_parent().add_child(sword)
		attack_timer.start()
		do_attack_timer.start()
		is_attacking = true
		can_attack = false

func _handle_death_animation() -> void:
	$DeathSound.play()
	_handle_death()

func _handle_damage_animation(damage_orientation : Vector2) -> void:
	damage_timer.start()
	skin.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
#	knockback = damage_orientation.normalized()
	knockback = Vector2.ZERO
	is_taking_damage = true


### PUBLIC METHODS ###

func take_damage(damage_amount : int, damage_orientation : Vector2) -> void:
	health = health - damage_amount
	if (health <= 0):
		is_alive = false
		_handle_death_animation()
	else:
		_handle_damage_animation(damage_orientation)


### PRIVATE SIGNALS ###

func _on_DetectionArea_body_entered(body):
	players = get_tree().get_nodes_in_group("player")
	if players.has(body):
		player = players[players.find(body)]

func _on_DetectionArea_body_exited(body):
	if body == player:
		player = null

func _on_AttackTimer_timeout():
	can_attack = true

func _on_DamageTimer_timeout():
	skin.self_modulate = Color(1, 1, 1)
	is_taking_damage = false

func _on_DoAttackTimer_timeout():
	is_attacking = false

func _on_UnSplitArea_body_entered(body):
	if get_tree().get_nodes_in_group("mobs").has(body):
		mobs_view.push_back(body)

func _on_UnSplitArea_body_exited(body):
	if mobs_view.has(body):
		mobs_view.erase(body)
