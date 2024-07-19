extends Camera2D

@export var max_dist:Vector2 = Vector2(50, 50)
@export var camera_offset: Vector2 = Vector2(0,0)

@onready var player = $"../2DPlayer"

var camera_look_off: float

func _process(_delta) -> void:
	var mouse_pos = get_local_mouse_position()
	var des_pos = (player.position + mouse_pos)
	des_pos = des_pos.clamp(player.position - max_dist, player.position + max_dist)
	position = des_pos + camera_offset



