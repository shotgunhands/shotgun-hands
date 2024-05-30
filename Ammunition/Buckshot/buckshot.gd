extends AmmoType


func fire(pivot: Node2D):
	super.fire(pivot)


func _send_visual_pellet(angle: float, start_pos: Vector2):
	super._send_visual_pellet(angle, start_pos)
