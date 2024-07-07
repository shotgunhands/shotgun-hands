extends Node2D

@onready var _player: CharacterBody2D = $".."
@onready var _pivot: Node2D = _player.get_node("ShotgunPivot")

@onready var _reload_timer: Timer = $ReloadTimer

const SCALE = 100.0

@export var _default_ammo: Array[PackedScene]
@onready var _ammo_types: Array[AmmoType] = []

@onready var _shotgun_jump_timer: Timer = $ShotgunJumpTimer
@export var _shotgun_jump_blast_force: float = 5
var _can_shotgun_jump = false

var _touched_ground = 0

@onready var _melee_duration_timer: Timer = $"MeleeTimers/MeleeDuration"
@onready var _melee_cooldown_timer: Timer = $"MeleeTimers/MeleeCooldown"
@export var _melee_cooldown_duration: float = 0.5
@export var _overheated_melee_cooldown_duration: float = 0.1

@onready var _melee_hurtbox: Area2D = _pivot.get_node("MeleeHurtbox")
@onready var _debug_melee_display: Polygon2D = _melee_hurtbox.get_node("Polygon2D")

@export var _melee_damage: float

@export var _overheat_melee_damage: float
var _overheat: int = 0
var _is_overheated: bool = false
const OVERHEAT_THRESHOLD: int = 8
@export var _overheat_timer: Timer
@export var _placeholder_visual_box: Polygon2D
@export var _default_color: Color
@export var _overheated_color: Color

signal hit_enemy
signal midair_shot


func _ready():
	_ammo_types.append(_default_ammo[0].instantiate())
	_ammo_types.append(_default_ammo[1].instantiate())
	add_child(_ammo_types[0]); add_child(_ammo_types[1])
	_melee_cooldown_timer.wait_time = _melee_cooldown_duration


# the structure here should *really* be changed, though right now im electing
# to wait until some discussion is done abt this :P ~wdbros
func _process(_delta):
	if _player.is_on_floor():
		_touched_ground = 0
	
	_aim()
	
	if Input.is_action_just_pressed("fire_left"):
		_fire(0)
	if Input.is_action_just_pressed("fire_right"):
		_fire(1)
	
	if Input.is_action_just_pressed("fire_reload"):
		_reload()
	
	if Input.is_action_just_pressed("fire_melee"):
		_melee()


func _aim():
	# pick a sprite or rotate it or whatev here
	_pivot.look_at(_pivot.get_global_mouse_position())


func _fire(mouse: int):
	if _is_overheated:
		print("overheat")
		return
	if _ammo_types[mouse].ammo <= 0 or not _reload_timer.is_stopped() or not _ammo_types[mouse].can_fire:
		print("no ammo")
		return
	
	var r_pars = PhysicsPointQueryParameters2D.new()
	r_pars.collision_mask = 0b00_0000_0010
	r_pars.collide_with_areas = true
	r_pars.position = _pivot.find_child("Reticle").global_position
	if get_viewport().world_2d.direct_space_state.intersect_point(r_pars, 1):
		print("in wall")
		return
	_increment_overheat()

	if not _player.is_on_floor() and _can_shotgun_jump:
		_touched_ground += 1
		_launch()
	
	_ammo_types[mouse].fire(_pivot)
	
	if not _can_shotgun_jump and _touched_ground < 2:
		_can_shotgun_jump = true
		_shotgun_jump_timer.start()


func _reload():
	if _ammo_types[0].ammo != _ammo_types[0].max_ammo\
	   or _ammo_types[1].ammo != _ammo_types[1].max_ammo:
		_reload_timer.start()


func _melee():
	if not _melee_cooldown_timer.is_stopped():
		return
	await _melee_hit()
	_melee_cooldown_timer.start()


func _melee_hit():
	_melee_duration_timer.start()
	_melee_hurtbox.monitoring = true
	_debug_melee_display.visible = true

	await _melee_duration_timer.timeout
	_melee_hurtbox.monitoring = false
	_debug_melee_display.visible = false


func _on_hurtbox_entered(area: HittableComponent):
	if _is_overheated:
		print("Doing overheated damage!")
		area.hurt(_overheat_melee_damage)
	else:
		print("Doing normal damage!")
		area.hurt(_melee_damage)


func _reloaded():
	_ammo_types[0].ammo = _ammo_types[0].max_ammo
	_ammo_types[1].ammo = _ammo_types[1].max_ammo


func _shotgun_jump_timeout():
	_can_shotgun_jump = false


func _increment_overheat():
	_overheat += 1
	_overheat_timer.start()
	if _overheat > OVERHEAT_THRESHOLD:
		_start_overheat()


func _overheat_timeout():
	_overheat -= 1
	if _overheat > 0:
		_overheat_timer.start()
	if _overheat == 0:
		_end_overheat()


func _start_overheat():
	_is_overheated = true
	_melee_cooldown_timer.wait_time = _overheated_melee_cooldown_duration
	_placeholder_visual_box.color = _overheated_color


func _end_overheat():
	_is_overheated = false
	_melee_cooldown_timer.wait_time = _melee_cooldown_duration
	_placeholder_visual_box.color = _default_color


func _launch(): # particle effects go here
	_player.velocity = Vector2.RIGHT.rotated(_pivot.rotation) * _shotgun_jump_blast_force * SCALE * -1
	emit_signal("midair_shot")
