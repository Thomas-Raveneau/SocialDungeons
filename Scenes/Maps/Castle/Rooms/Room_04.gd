extends Node2D

################################################################################

# SCENES
var mobs = [
	preload("res://Scenes/Mobs/Mage.tscn"),
	preload("res://Scenes/Mobs/WalkingMan.tscn")
]

# NODES
onready var door_animation = $Door/OpeningAnimation
onready var door_closed_collision = $Door/ClosedCollision
onready var door_opened_collision_left = $Door/OpenedCollisionLeft
onready var door_opened_collision_right = $Door/OpenedCollisionRight
onready var mob_spawn_delay: Timer = $MobSpawnDelay
onready var mobs_spawns = [
	$MobsSpawns/TopLeft,
	$MobsSpawns/TopRight,
	$MobsSpawns/BottomLeft,
	$MobsSpawns/BottomRight
]

# LEVEL DIFFICULTY
export var MOB_AMOUNT: int = 20

export var SPAWN_DELAY: float = 4.0

# UTILS
var mob_index: int = 0

################################################################################

### PRIVATE ###
func _ready():
	door_opened_collision_left.disabled = true
	door_opened_collision_right.disabled = true
	mob_spawn_delay.wait_time = SPAWN_DELAY
	mob_spawn_delay.start()

func _spawn_random_mob() -> void:
	randomize()
	var mob_type = mobs[randi() % mobs.size()]
	var spawn_point: Position2D = mobs_spawns[randi() % mobs_spawns.size()]
	
	var new_mob = mob_type.instance()
	new_mob.position = spawn_point.position
	add_child(new_mob)

### PUBLIC ###
func open_door():
	door_animation.play("open")
	door_closed_collision.disabled = true
	door_opened_collision_left.disabled = false
	door_opened_collision_right.disabled = false

func close_door():
	door_animation.stop()
	door_animation.frame = 0
	door_closed_collision.disabled = false
	door_opened_collision_left.disabled = true
	door_opened_collision_right.disabled = true

### SIGNALS ###
func _on_MobSpawnDelay_timeout():
	if (mob_index < MOB_AMOUNT - 1):
		_spawn_random_mob()
		mob_index += 1
