extends Node

@onready var _player: CharacterBody2D = $".."
@onready var _pivot: Node2D = _player.get_node("ShotgunPivot")

@onready var _reload_timer: Timer = $ReloadTimer

const SCALE = 100.0

@export var _default_ammo: Array[PackedScene]
@onready var _ammo_types: Array[AmmoType] = []

signal hit_enemy
signal midair_shot


func _ready():
	_ammo_types.append(_default_ammo[0].instantiate())
	_ammo_types.append(_default_ammo[1].instantiate())
	add_child(_ammo_types[0]); add_child(_ammo_types[1])


# the structure here should *really* be changed, though right now im electing
# to wait until some discussion is done abt this :P ~wdbros
func _process(_delta):
	if _player.is_on_floor():
		_ammo_types[0].touched_ground = true
		_ammo_types[1].touched_ground = true
	
	_aim()
	
	if Input.is_action_just_pressed("fire_left"):
		_fire(0)
	if Input.is_action_just_pressed("fire_right"):
		_fire(1)
	
	if Input.is_action_just_pressed("fire_reload"):
		_reload()


func _aim():
	# pick a sprite or rotate it or whatev here
	_pivot.look_at(_pivot.get_global_mouse_position())


func _fire(mouse: int):
	if _ammo_types[mouse].ammo <= 0 or not _reload_timer.is_stopped():
		return
	
	_ammo_types[mouse].fire(_player, _pivot)
	
	if not _player.is_on_floor() and _ammo_types[mouse].touched_ground:
		_launch(mouse)
		_ammo_types[mouse].touched_ground = false


func _reload():
	if _ammo_types[0].ammo != _ammo_types[0].max_ammo\
	   or _ammo_types[1].ammo != _ammo_types[1].max_ammo:
		_reload_timer.start()


func _reloaded():
	_ammo_types[0].ammo = _ammo_types[0].max_ammo
	_ammo_types[1].ammo = _ammo_types[1].max_ammo


func _launch(mouse: int):
	# particle effects go here
	_player.velocity = Vector2.RIGHT.rotated(_pivot.rotation) * _ammo_types[mouse].blast_force * SCALE * -1
	emit_signal("midair_shot")
