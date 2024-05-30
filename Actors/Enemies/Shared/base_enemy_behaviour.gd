class_name BaseEnemyBehaviour
extends CharacterBody2D

var _states: Dictionary = {
	"IDLE": _idle_logic,
	"CHASE": _chase_logic,
	"ATTACK": _attack_logic,
}
var _current_state: String = "IDLE"

const VIEW_ANGLE: float = 80

@export_range(0, 100.0) var gravity = 98.1

### METHODS ###
func _ready():
	pass

func _physics_process(_delta) -> void:
	# apply gravity
	if not is_on_floor():
		velocity.y += gravity

	_state_logic()

	_states[_current_state].call()

func _state_logic() -> void:
	pass

func _idle_logic() -> void:
	pass

func _chase_logic() -> void:
	pass

func _attack_logic() -> void:
	pass

# func _check_can_see() -> bool:
# 	var space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

# 	var from: Vector2 = global_transform.origin
# 	var to: Vector2 = player.global_transform.origin

# 	var query = PhysicsRayQueryParameters2D.create(from, to)
# 	query.exclude = [self]

# 	var result = space_state.intersect_ray(query)

# 	return result["collider"].is_in_group("Player") if !result.is_empty() && result["collider"] != null else false
