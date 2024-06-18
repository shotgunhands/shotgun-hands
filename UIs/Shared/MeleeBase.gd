class_name MeleeBase
extends CharacterBody2D

### CONSTANTS ###
###Acid Range
@export var RANGED_ATTACK_RANGE = 500
###Fist Range
@export var MEL_ATTACK_RANGE = 100
@export var SPEED = 150
@export var GRAVITY = 20
@export var JUMP_SPEED = -500
@export var ATTACK_COOLDOWN = 1.5
### ENUMS ###
enum State {
	IDLE,
	CHASE,
	ATTACK
}

### VARIABLES ###
var enemyHealth = 1000
var has_seen: bool         = false
var direction: float       = 1
var player:Node2D          = null
var state:State            = State.IDLE
var last_attack_time:float = 0.0
var fistScene = load("res://Actors/Enemies/Shared/MeleeSlash.tscn")
### METHODS ###
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(_delta) -> void:
	if !is_on_floor(): velocity.y += GRAVITY
	if (enemyHealth <=0):
		queue_free()
	state_logic()
	move_and_slide()

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

func idle_logic() -> void:
	velocity.x = 0

func chase_logic() -> void:
	var dir_to_player = (player.global_position - global_position).normalized()
	velocity.x = SPEED * dir_to_player.x

func attack_logic() -> void:
	var distance_to_player = player.global_position.distance_to(global_position)
	var current_time = Time.get_ticks_msec() / 1000.0
	###Fist
	if current_time - last_attack_time > ATTACK_COOLDOWN and distance_to_player <= MEL_ATTACK_RANGE:
		last_attack_time = current_time
		mel_attack ()
	var dir_to_player = (player.global_position - global_position).normalized()
	velocity.x = SPEED * dir_to_player.x	
func check_can_see() -> bool:
	var space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

	var from: Vector2 = global_transform.origin
	var to: Vector2 = player.global_transform.origin

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result = space_state.intersect_ray(query)

	return result["collider"].is_in_group("Player") if !result.is_empty() && result["collider"] != null else false

func mel_attack () -> void:
	var fist = fistScene.instantiate()
	add_child(fist)
