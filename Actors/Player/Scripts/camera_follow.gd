class_name Camera extends Camera2D

@export var SmoothCamera : bool = true
@export var SmoothSpeed : float = 10.0 # Speed of camera smoothing
@export var MouseInfluence : float = 0.2 # How much the mouse position influences the camera

@onready var player = $"../2DPlayer"

var camera_look_off: float

func _process(_delta) -> void:
	if player == null:
		return

	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport_rect().size
	var mouse_offset = (mouse_pos - viewport_size / 2) * MouseInfluence

	position = player.position + mouse_offset
