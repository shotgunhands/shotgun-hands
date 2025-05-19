extends Node
class_name AmmoType

# if distance < effective_range[x]:
# 	do damage[x] damage to enemy
# else:
# 	do damage[-1] damage to enemy
# it is begging for a different implementation though ngl
@export var effective_range: Array[float]
@export var damage: Array[float]

@export var _pellet: PackedScene
@export var _pellet_count: int
@export var _pellet_spread_angle: int ## in degrees :pensive:

@export var blast_force: float

var _angle_offsets: Array[float] = []

## returns a list of floats representing the offset for each _pellet
func get_angle_offsets() -> Array[float]:
	if not _angle_offsets.is_empty():
		return _angle_offsets

	var output: Array[float] = []
	if _pellet_count > 1:
		for pellet in range(_pellet_count): # this is so disgusting i'm sorry
			output.append(((-deg_to_rad(_pellet_spread_angle) / 2.0) + \
					(pellet * (deg_to_rad(_pellet_spread_angle) / (_pellet_count - 1.0)))))
	else:
		output = [0]
	_angle_offsets = output
	return _angle_offsets


## returns damage based on passed distance
func get_damage(distance: float) -> float:
	if distance < 0: return -1.0

	if effective_range.is_empty():
		return damage[0]

	for _range in effective_range: # underscore to avoid shadowing "range"
		if distance < _range:
			return damage[effective_range.find(_range)]

	return damage.back()

#region interface

func fire(shoot_angle:float, shoot_position: Vector2, damage_mask: int):
	#can_fire = false
	#_cooldown_timer.start()

	var angle_offsets := get_angle_offsets()
	#var shoot_angle :=pivot.global_rotation
	#var shoot_position :Vector2= pivot.find_child("Reticle").global_position
	for offset in angle_offsets:

		var angle := shoot_angle + offset
		var stop_pos:Vector2
		var r_info := cast_ray(shoot_position, shoot_position + Vector2.RIGHT.rotated(angle) * 6000.0, 0b00_0000_0010)
		if r_info:
			#hit_info.add_collider(r_info["collider"], reticle.global_position.distance_to(r_info["position"]))
			stop_pos = Vector2(r_info["position"]["x"],r_info["position"]["y"])
		_send_visual_pellet(angle, shoot_position, stop_pos, damage_mask,self)

	#hit_info.apply_damage(self)


## given an angle offset, sends a ray in the given direction
func cast_ray(start: Vector2, target: Vector2, layer_mask:int) -> Dictionary:
	var state := get_viewport().world_2d.direct_space_state
	var r_pars := PhysicsRayQueryParameters2D.create(start, target, layer_mask)
	r_pars.collide_with_areas = true
	return state.intersect_ray(r_pars)


## create pellet, set varables then start script running
func _send_visual_pellet(angle: float, start_pos: Vector2,stop_pos:Vector2, damage_mask: int, ammo_base:AmmoType):
=======
## empty for now. may be useful as an interface for different ammo types
func _send_visual_pellet(angle: float, start_pos: Vector2, ammo_base:AmmoType):


	#make sure not to set any varibles for the pallet after this point
=======
	return visual
#endregion
