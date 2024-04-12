extends Node

@onready var _player = $".."
@onready var _pivot = _player.get_node("ShotgunPivot")

@export_range(1.0, 100.0) var blast_force = 5.0

const SCALE = 100.0

signal midair_shot

# the structure here should *really* be changed, though right now im electing
# to wait until some discussion is done abt this :P ~wdbros
func _process(_delta):
	_aim()
	
	if Input.is_action_just_pressed("fire_left"):
		# do gun firing things
		
		# launch player if midair
		if not _player.is_on_floor():
			_launch()
			

func _aim():
	# pick a sprite or rotate it or whatev here
	_pivot.look_at(_pivot.get_global_mouse_position())
	
func _launch():
	# particle effects go here
	_player.velocity = Vector2.RIGHT.rotated(_pivot.rotation) * blast_force * SCALE * -1
	emit_signal("midair_shot")
