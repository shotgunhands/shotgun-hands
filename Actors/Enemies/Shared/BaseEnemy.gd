class_name BaseEnemy extends HitableCharacterBody

### CONSTANTS ###

@export_group("Attack")
@export var MEL_ATTACK_RANGE = 100
@export var ATTACK_COOLDOWN = 1.0

@export_group("Movement")
@export var SPEED = 200
@export var GRAVITY = 20
@export var JUMP_SPEED = -500

@export_group("Vision")
@export var CONE_ANGLE = 45.0
@export var MEMORY_DURATION = 10.0

### ENUMS ###
enum State {
	IDLE,
	CHASE,
	ATTACK
}

### VARIABLES ###
var direction: float        = 1
var player: Node2D          = null
var state: State            = State.IDLE
var last_attack_time: float = 0.0
var memory: float   = 0.0

### METHODS ###
func _ready():
	super()
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(_delta) -> void:
	if kill_check(): return

	if !is_on_floor(): velocity.y += GRAVITY

	state_logic()
	move_and_slide()

func state_logic() -> void:


	var can_see_player: bool = memory != 0
	var distance_to_player = player.global_position.distance_to(global_position)

	if can_see_player and distance_to_player <= MEL_ATTACK_RANGE:
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
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_attack_time > ATTACK_COOLDOWN:
		mel_attack()
		last_attack_time = current_time

func check_can_see() -> bool:
	var from: Vector2 = global_transform.origin
	var to: Vector2 = player.global_transform.origin

	# Calculate the angle between the enemy's direction and the direction to the player
	var dir_to_player = (to - from).normalized()
	var angle = rad_to_deg(acos(dir_to_player.dot(Vector2.RIGHT)))

	# Check if the player is within the cone of vision
	if abs(angle) <= CONE_ANGLE / 2.0:
		# Implementing LOS using ray-casting
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(from, to, collision_mask, [self]))

		# If the ray hits something before hitting the player, LOS is blocked
		if result and result["collider"] != player:
			return false

		return true

	return false


func mel_attack() -> void:
	player.health -= 10
