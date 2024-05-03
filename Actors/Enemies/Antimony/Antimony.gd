class_name Antimony extends BaseEnemy

### CONSTANTS ###

# Acid Range
@export var RANGED_ATTACK_RANGE = 500

# Fist Range
@export var GRENADE_COOLDOWN = 10

var acidScene = preload("res://Actors/Enemies/Antimony/antimony_acid.tscn")
var fistScene = preload("res://Actors/Enemies/Antimony/antimony_fist.tscn")
var grenadeScene = preload("res://Actors/Enemies/Antimony/antimony_grenade.tscn")

### VARIABLES ###

var last_grenade_attack_time:float = 0.0

### METHODS ###

func _ready():
	super()
	player = get_tree().get_nodes_in_group("Player")[0]

func state_logic() -> void:
	var can_see_player = check_can_see()
	var distance_to_player = player.global_position.distance_to(global_position)

	if can_see_player and distance_to_player <= RANGED_ATTACK_RANGE:
		state = State.ATTACK
	elif can_see_player:
		state = State.CHASE
	else:
		state = State.IDLE

	match state:
		State.IDLE:
			idle_logic()
		State.CHASE:
			chase_logic()
		State.ATTACK:
			attack_logic()

func attack_logic() -> void:
	var distance_to_player = player.global_position.distance_to(global_position)
	var current_time = Time.get_ticks_msec() / 1000.0

	# Fist
	if current_time - last_attack_time > ATTACK_COOLDOWN and distance_to_player <= MEL_ATTACK_RANGE:
		last_attack_time = current_time
		mel_attack ()

	# Acid
	if current_time - last_attack_time > ATTACK_COOLDOWN:
		ranged_attack()
		last_attack_time = current_time

	# Grenade
	if current_time - last_grenade_attack_time > GRENADE_COOLDOWN:
		grenade_attack()
		last_grenade_attack_time = current_time

	var dir_to_player = (player.global_position - global_position).normalized()
	velocity.x = SPEED * dir_to_player.x

func mel_attack () -> void:
	var fist = fistScene.instantiate()
	add_child(fist)

func ranged_attack() -> void:
	var acid = acidScene.instantiate()
	add_child(acid)

func grenade_attack()-> void:
	var grenade = grenadeScene.instantiate()
	add_child(grenade)
