extends Node2D

@export var _pellet_speed: float = 15.0

var final_pos: Vector2
var _has_final_pos: bool = false


func _start():
	if final_pos != Vector2.ZERO:
		_has_final_pos = true


func _physics_process(_delta):
	if _has_final_pos:
		global_position = global_position.move_toward(final_pos, _pellet_speed)
	else:
		global_position += Vector2.RIGHT.rotated(rotation) * _pellet_speed


func destroy():
	queue_free()
