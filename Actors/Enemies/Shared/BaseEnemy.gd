class_name BaseEnemy
extends CharacterBody2D

# Constants
@export var SPEED = 200
@export var GRAVITY = 20
@export var JUMP_SPEED = -500

# Variables
var has_seen: bool = false;
var direction = 1
var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../2DPlayer") # TODO: there is probably a better way to do this

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	velocity.y += GRAVITY
	move_logic(delta)
	move_and_slide()

func move_logic(_delta:float) -> void:
	# AI logic to move left and right
	if is_on_wall():
		direction *= -1

	if check_can_see(): has_seen = true

	# If the player is visible, chase the player
	if has_seen:
		var dir_to_player = (player.global_position - global_position).normalized()
		velocity.x = SPEED * dir_to_player.x
	else:
		velocity.x = SPEED * direction

func check_can_see() -> bool:
	var space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

	var from: Vector2 = global_transform.origin
	var to: Vector2 = player.global_transform.origin

	from.y -= 45

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result = space_state.intersect_ray(query)

	return result["collider"].is_in_group("Player") if !result.is_empty() && result["collider"] != null else false
