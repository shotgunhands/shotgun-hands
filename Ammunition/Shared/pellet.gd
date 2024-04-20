extends Node2D

@export var pellet_speed: float = 15.0

var final_pos: Vector2
var has_final_pos: bool = false


func _start():
	if final_pos != Vector2.ZERO:
		has_final_pos = true


func _physics_process(_delta):
	if has_final_pos:
		global_position = global_position.move_toward(final_pos, pellet_speed)
	else:
		global_position += Vector2.RIGHT.rotated(rotation) * pellet_speed


func destroy():
	queue_free()
