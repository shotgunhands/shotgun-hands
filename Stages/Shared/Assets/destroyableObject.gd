extends RigidBody2D

func _on_area_2d_die_father():
	queue_free()
