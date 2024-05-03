extends Node
class_name AmmoType

# if distance < effective_range[x]:
# 	do damage[x] damage to enemy
# else:
# 	do damage[-1] damage to enemy
# it is begging for a different implementation though ngl
@export var effective_range: Array[float]
@export var damage: Array[float]
@export var max_ammo: int
@onready var ammo: int = max_ammo

var touched_ground = true

@export var _pellet: PackedScene
@export var _pellet_count: int
@export var _pellet_spread_angle: int # in degrees :pensive:

@export var blast_force: float

var _angle_offsets: Array[float] = []


# returns a list of floats representing the offset for each _pellet
func get_angle_offsets() -> Array[float]:
	if not _angle_offsets.is_empty():
		return _angle_offsets
		
	var output: Array[float] = []
	for pellet in range(_pellet_count): # this is so disgusting i'm sorry
		output.append(((-deg_to_rad(_pellet_spread_angle) / 2.0) + \
				(pellet * (deg_to_rad(_pellet_spread_angle) / (_pellet_count - 1.0)))))
	_angle_offsets = output
	return _angle_offsets


# returns damage based on passed distance
func get_damage(distance: float) -> float:
	if distance < 0: return -1.0
	
	if effective_range.is_empty():
		return damage[0]
	
	for _range in effective_range: # underscore to avoid shadowing "range"
		if distance < _range:
			return damage[effective_range.find(_range)]
	
	return damage.back()


#region interface
func fire(player: CharacterBody2D, pivot: Node2D):
	ammo -= 1
	pass


# given an angle offset, sends a ray in the given direction
func _cast_ray(start: Vector2, target: Vector2) -> Dictionary:
	var state = get_viewport().world_2d.direct_space_state
	var r_pars = PhysicsRayQueryParameters2D.create(start, target, 0b1_0000_0001)
	return state.intersect_ray(r_pars)


# empty for now. may be useful as an interface for different ammo types
func _send_visual_pellet(angle: float, start_pos: Vector2, final_pos: Vector2, parent: Node):
	pass
#endregion

