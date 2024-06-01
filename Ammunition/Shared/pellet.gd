extends Node2D

@export var _pellet_speed: float = 15.0


func _physics_process(_delta):
	global_position += Vector2.RIGHT.rotated(rotation) * _pellet_speed


func destroy():
	queue_free()
