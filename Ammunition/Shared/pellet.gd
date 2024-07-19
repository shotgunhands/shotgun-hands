extends Node2D
#defined externally
@export var _pellet_speed: float = 0;

var stop_pos:Vector2;
var ammo_base:AmmoType;
var _start_position:Vector2;

@warning_ignore("unassigned_variable")
var unset_vec2 :Vector2;
func _ready():
	#bug that required this should be fixed
	assert(global_position != unset_vec2)
	
	_start_position = global_position;
func _physics_process(_delta):
	var old_position := global_position;
	#TODO find best distance to check
	var position_delta := Vector2.RIGHT.rotated(rotation) * _pellet_speed;
	var target := global_position + position_delta
	#detect if bullet will hit enemy if it moves
	var r_info := _cast_enemy_ray(global_position, target)
	if r_info:
		var damage := ammo_base.get_damage(_start_position.distance_to(r_info["position"]));
		r_info["collider"].hurt(damage)
		print("visual hit enemy for ",damage)
		destroy()
		return
	#move
	global_position += position_delta
	#if check to stop case where there is no predicted target (i.e. it goes offscreen) otherwise it casts itself to (0,0)
	if stop_pos != unset_vec2:
		#Check if the bullet has overshot the desired position
		if old_position.distance_squared_to(stop_pos) <= global_position.distance_squared_to(stop_pos):
			print("visual hit env")
			destroy()
			return
#called by DestroyTimer
func destroy():
	#print("assumed ",stop_pos," true ",global_position)
	queue_free()
func _cast_enemy_ray(start: Vector2, target: Vector2) -> Dictionary:
	var state = get_viewport().world_2d.direct_space_state
	#only triggers for enemies and destructables
	var r_pars = PhysicsRayQueryParameters2D.create(start, target, 0b11_0000_0000)
	r_pars.collide_with_areas = true
	return state.intersect_ray(r_pars)
