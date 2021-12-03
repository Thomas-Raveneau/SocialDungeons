extends "res://Scenes/Mobs/AMonster.gd"

######################### VARIABLES ############################################

# HITBOX
onready var hitbox : CollisionShape2D = $Hitbox

# ATTACK
export var HIT_COOLDOWN : int = 0
onready var hit_sprite : Sprite = $HitSprite
onready var hit_timer : Timer = $HitTimer
var can_hit : bool = true
var current_target = null
var saved_move_direction: Vector2 = Vector2(0, 0)

# ANIMATION
onready var animation = $AnimatedSprite

######################### PRIVATE METHODS ######################################

func _ready():
	._ready()
	hit_timer.wait_time = HIT_COOLDOWN
	KNOCKBACK_FORCE = 60

func _physics_process(_delta):
	if is_alive:
		_handle_movement()
		_handle_flip()
		_handle_animation()
		_handle_collision()

func _handle_movement():
	if target:
		velocity = position.direction_to(target.position) * SPEED
	velocity = move_and_slide(velocity)

func _handle_flip():
	if ($DamageTimer.time_left > 0):
		return
	elif (velocity.x < 0 and !animation.flip_h and int($DamageTimer.time_left) == 0):
		print($DamageTimer.time_left)
		animation.flip_h = true
	elif (velocity.x > 0 and animation.flip_h and int($DamageTimer.time_left) == 0):
		animation.flip_h = false

func _handle_animation():
	if velocity == Vector2.ZERO:
		animation.play('idle')
	else:
		animation.play('run')

func _handle_collision():
	var slide_count = get_slide_count()
	for i in slide_count:
		var node = get_slide_collision(i)
		if hitbox.disabled or !node:
			continue
		if get_tree().get_nodes_in_group("player").has(node.collider) and can_hit:
			_handle_attack(node)
		if get_tree().get_nodes_in_group("projectile").has(node.collider):
			$DamageTimer.start()
			saved_move_direction = velocity
			target = null
			animation.self_modulate = Color(235/255.0, 70/255.0, 70/255.0)
			take_damage(node.collider.DAMAGE, node.collider.orientation)
			node.collider.destroy()

func _handle_attack(node):
	node.collider.damage(DAMAGE, position - node.collider.position)
	hit_timer.start()
	can_hit = false
	hit_sprite.visible = false

func _handle_death_animation() -> void:
	$DeathSound.play()
	_handle_death()

######################### PRIVATE SIGNALS ######################################

func _on_DetectionArea_body_entered(body):
	players_list = get_tree().get_nodes_in_group("player")
	if players_list.has(body):
		target = players_list[players_list.find(body)]
		current_target = target

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null

func _on_HitTimer_timeout():
	can_hit = true
	hit_sprite.visible = true

func _on_DamageTimer_timeout() -> void:
	animation.self_modulate = Color(1, 1, 1)
	target = current_target



