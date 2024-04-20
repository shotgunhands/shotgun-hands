extends Node

@onready var _player: CharacterBody2D = $".."
@onready var _pivot: Node2D = _player.get_node("ShotgunPivot")
@onready var _reticle: Node2D = _pivot.get_node("Reticle")

@onready var _reload_timer: Timer = $ReloadTimer

@export_range(1.0, 100.0) var blast_force = 5.0

const SCALE = 100.0

@export var _ammo_types: Array[AmmoType]

@onready var _max_ammo: Array[int] = [_ammo_types[0].max_ammo, _ammo_types[1].max_ammo]
@onready var _ammo: Array[int] = [_ammo_types[0].max_ammo, _ammo_types[1].max_ammo]

@export var pellet: PackedScene

var _touched_ground: Array[bool] = [true, true]

signal hit_enemy
signal midair_shot


# the structure here should *really* be changed, though right now im electing
# to wait until some discussion is done abt this :P ~wdbros
func _process(_delta):
	if _player.is_on_floor():
		_touched_ground = [true, true]
	
	_aim()
	
	if Input.is_action_just_pressed("fire_left"): _fire(0)
	if Input.is_action_just_pressed("fire_right"): _fire(1)
	
	if Input.is_action_just_pressed("fire_reload"): _reload()


func _aim():
	# pick a sprite or rotate it or whatev here
	_pivot.look_at(_pivot.get_global_mouse_position())


func _fire(mouse: int):
	if _ammo[mouse] <= 0 or not _reload_timer.is_stopped():
		return
	
	_ammo[mouse] -= 1
	
	_cast_pellets(mouse)
	
	if not _player.is_on_floor() and _touched_ground[mouse]:
		_launch()
		_touched_ground[mouse] = false


# will return a list of hit enemies as well as distances to them (possibly make some struct for this)
# void for now, though
func _cast_pellets(mouse: int):
	var angle_offsets = _ammo_types[mouse].get_angle_offsets()
	var state = get_viewport().world_2d.direct_space_state
	for offset in angle_offsets: # really gotta write this out on paper...
		var angle = _pivot.global_rotation + offset
		var target: Vector2 = _reticle.global_position + Vector2.RIGHT.rotated(angle) * 6000.0
		var r_pars = PhysicsRayQueryParameters2D.create(_reticle.global_position, target, 0b1_0000_0001)
		var r_info = state.intersect_ray(r_pars)
		
		var final_pos: Vector2 = Vector2.ZERO
		var parent: Node = get_tree().root
		if r_info:
			if r_info["collider"].get_collision_layer_value(9):
				print("Hit an enemy!")
			else:
				final_pos = r_info["position"]
				print("Hit the environment.")
		
		_send_visual_pellet(angle, final_pos, parent)


func _send_visual_pellet(angle: float, final_pos: Vector2, parent: Node):
	var visual = pellet.instantiate()
	get_tree().root.add_child(visual)
	visual.global_position = _reticle.global_position
	visual.global_rotation = angle
	visual.final_pos = final_pos
	visual._start()


func _reload():
	if _ammo != _max_ammo:
		_reload_timer.start()


func _reloaded():
	_ammo.assign(_max_ammo)


func _launch():
	# particle effects go here
	_player.velocity = Vector2.RIGHT.rotated(_pivot.rotation) * blast_force * SCALE * -1
	emit_signal("midair_shot")
