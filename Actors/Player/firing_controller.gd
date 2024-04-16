extends Node

@onready var _player = $".."
@onready var _pivot = _player.get_node("ShotgunPivot")

@onready var _reload_timer: Timer = $ReloadTimer

@export_range(1.0, 100.0) var blast_force = 5.0

const SCALE = 100.0

#var _ammo_type_left_hand: AmmoType
#var _ammo_type_right_hand: AmmoType

var _max_ammo: Array[int] = [6, 6]
var _ammo: Array[int] = [6, 6]

var _touched_ground: Array[bool] = [true, true]

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
	
	if not _player.is_on_floor() and _touched_ground[mouse]:
		_launch()
		_touched_ground[mouse] = false


func _reload():
	if _ammo != _max_ammo:
		_reload_timer.start()


func _reloaded():
	_ammo.assign(_max_ammo)


func _launch():
	# particle effects go here
	_player.velocity = Vector2.RIGHT.rotated(_pivot.rotation) * blast_force * SCALE * -1
	emit_signal("midair_shot")
