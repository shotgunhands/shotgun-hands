extends BaseEnemyBehaviour
class_name ShootTestEnemy
#TODO: generalise this so that the player is located through other mans, do same for camera_controller script
@onready var player = $"../../2DPlayer"
#TODO: needs to be replaced with a timer
@export var wait_time: float = 5;

@export var _default_ammo: PackedScene
@onready var ammo: AmmoType

var can_fire := true
@export var shoot_timer: Timer
func _ready() -> void:
	ammo = _default_ammo.instantiate()
	add_child(ammo);
	
func _idle_logic() -> void:
	velocity.x = 0
	move_and_slide()

func _on_destroy() -> void:
	queue_free()
	
func _process(_delta) -> void:
	if can_fire:
		#check if anything is between player and goal
		var r_info := _cast_ray(global_position,player.global_position,0b00_0000_0010) #
		#print(global_position,player.global_position,r_info)
		if r_info:
			pass #print("can't shoot")
		else:
			#check if anything is between start and end
			can_fire = false
			shoot_timer.start()
			var angle := global_position.angle_to_point(player.global_position)
			ammo.fire(angle,global_position,0b00_0001_0000)
		
##NOTICE: both functions are directly copied from firing_controller

func _cast_ray(start: Vector2, target: Vector2, layer_mask:int) -> Dictionary:
	var state := get_viewport().world_2d.direct_space_state
	var r_pars := PhysicsRayQueryParameters2D.create(start, target, layer_mask)
	r_pars.collide_with_areas = true
	return state.intersect_ray(r_pars)



func _on_shoot_timer() -> void:
	can_fire = true
