extends Area2D

# STATS
export var COOLDOWN: float = 1.3
export var DAMAGE: float = 5

# NODES
onready var damage_timing: Timer = $DamageTiming
onready var spikes_cooldown: Timer = $SpikesCooldown
onready var spawn_activation: Timer = $SpawnActivation
onready var spikes_animation: AnimatedSprite = $SpikesAnimation
onready var spikes_sound: AudioStreamPlayer = $SpikesSound

# UTILS
var is_activated = false
var is_cooldown_available: bool = true
var is_player_in_trap: bool = false
var player_node: Node

### PRIVATE ###
func _ready():
	spawn_activation.start()
	spikes_cooldown.wait_time = COOLDOWN

func _process(delta):
	if (is_player_in_trap and is_cooldown_available and is_activated):
		_play_spikes_animation()
		damage_timing.start()

func _play_spikes_animation() -> void:
	spikes_animation.play()

func _reset_spikes_animation() -> void:
	spikes_animation.stop()
	spikes_animation.set_frame(0)

func _send_damage_to_player() -> void:
	player_node.damage(DAMAGE, Vector2.ZERO)

### PUBLIC ###

### SIGNALS ###
func _on_Trap_body_entered(body: Node) -> void:
	if (is_activated):
		if (get_tree().get_nodes_in_group("player").has(body)):
			is_player_in_trap = true
			player_node = body
			spikes_sound.play()

func _on_FloorSpikes_body_exited(body: Node) -> void:
	if (get_tree().get_nodes_in_group("player").has(body)):
		is_player_in_trap = false
		_reset_spikes_animation()

func _on_AnimatedSprite_animation_finished() -> void:
	is_cooldown_available = false
	_reset_spikes_animation()
	spikes_cooldown.start()

func _on_SpikesCooldown_timeout():
	is_cooldown_available = true

func _on_SpawnActivation_timeout():
	is_activated = true

func _on_DamageTiming_timeout():
	_send_damage_to_player()
