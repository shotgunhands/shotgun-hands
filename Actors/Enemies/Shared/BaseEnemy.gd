class_name BaseEnemy
extends HitableCharacterBody

### CONSTANTS ###
@export var MEL_ATTACK_RANGE = 100
@export var SPEED = 200
@export var GRAVITY = 20
@export var JUMP_SPEED = -500

### VARIABLES ###
var has_seen: bool = false;
var direction = 1
var player = null


### METHODS ###
func _ready():
	super()
	player = get_node("../2DPlayer") # TODO: there is probably a better way to do this

func _physics_process(delta) -> void:
	if kill_check(): return

	velocity.y += GRAVITY

	move_logic(delta)
	attack_logic()
	move_and_slide()

func move_logic(_delta:float) -> void:
	if is_on_wall():
		direction *= -1

	if check_can_see(): has_seen = true

	if has_seen:
		var dir_to_player = (player.global_position - global_position).normalized()
		velocity.x = SPEED * dir_to_player.x
	else:
		velocity.x = SPEED * direction

func attack_logic() -> void:
	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player <= MEL_ATTACK_RANGE:
		mel_attack()


func check_can_see() -> bool:
	var space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

	var from: Vector2 = global_transform.origin
	var to: Vector2 = player.global_transform.origin

	from.y -= 45

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result = space_state.intersect_ray(query)

	return result["collider"].is_in_group("Player") if !result.is_empty() && result["collider"] != null else false


func mel_attack() -> void:
	player.health -= 10
