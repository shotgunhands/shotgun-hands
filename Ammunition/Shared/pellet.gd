extends Node2D
#defined externally
@export var _pellet_speed: float = 0;

var stop_pos:Vector2;
var ammo_base:AmmoType;
var _start_position:Vector2;

#used to check if a uninitialised value has been used
@warning_ignore("unassigned_variable")
var unset_vec2 :Vector2;


func _ready() -> void:
	#make sure the position of the bullet have actually been set by the pellet creator
	assert(global_position != unset_vec2)
	_start_position = global_position;


func _physics_process(delta) -> void:
	var updated_position: Vector2 = _get_new_frame_position(delta)
	#detect if a bullet will hit an enemy when it moves
	var r_info := _cast_enemy_ray(global_position, updated_position)
	if r_info:
		var damage := ammo_base.get_damage(_start_position.distance_to(r_info["position"]));
		r_info["collider"].hurt(damage)
		print("visually hit enemy for ",damage)
		destroy()
		return
	
	#check to stop case where there is no predicted target (i.e. it goes offscreen) otherwise gdscript defaults to (0,0) being the stopping point
	if stop_pos != unset_vec2:
		#Check if the bullet has overshot the desired position, squared is used since it is faster
		if global_position.distance_squared_to(stop_pos) <= updated_position.distance_squared_to(stop_pos):
			#print("visual hit env")
			destroy()
			return
	else:
		pass
	#move to new position
	global_position = updated_position


func destroy():
	#print("assumed pos",stop_pos," true ",global_position)
	queue_free()	


func _cast_enemy_ray(start: Vector2, target: Vector2) -> Dictionary:
	var state := get_viewport().world_2d.direct_space_state
	#only triggers for enemies and destructables
	var r_pars := PhysicsRayQueryParameters2D.create(start, target, 0b11_0000_0000)
	r_pars.collide_with_areas = true
	return state.intersect_ray(r_pars)


func _get_new_frame_position(delta:float) -> Vector2:
	#TODO find best distance to check
	var position_delta: Vector2 = Vector2.RIGHT.rotated(rotation) * _pellet_speed * delta;
	return global_position + position_delta


func _get_old_frame_position(old_delta:float) -> Vector2:
	var position_delta: Vector2 = -1 * Vector2.RIGHT.rotated(rotation) * _pellet_speed * old_delta;
	return global_position + position_delta
