extends Resource
class_name AmmoType

# if distance < effective_range[x]:
# 	do damage[x] damage to enemy
# else:
# 	do damage[-1] damage to enemy
# it is begging for a different implementation though ngl
@export var effective_range: Array[float]
@export var damage: Array[float]
@export var max_ammo: float

@export var pellet_count: int
@export var pellet_spread_angle: int # in degrees :pensive:

@export var blast_force: float

@export var behaviors: AmmoTypeBehaviors

var _angle_offsets: Array[float] = []


# returns a list of floats representing the offset for each pellet
func get_angle_offsets() -> Array[float]:
	if not _angle_offsets.is_empty():
		return _angle_offsets
		
	var output: Array[float] = []
	for pellet in range(pellet_count): # this is so disgusting i'm sorry
		output.append(((-deg_to_rad(pellet_spread_angle) / 2.0) + \
				(pellet * (deg_to_rad(pellet_spread_angle) / (pellet_count - 1.0)))))
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
