extends AmmoType


func fire(pivot: Node2D, damage_mask:int):
	super.fire(pivot, damage_mask)


func _send_visual_pellet(angle: float, start_pos: Vector2, stop_pos: Vector2, damage_mask:int, ammo_base: AmmoType):
	super._send_visual_pellet(angle, start_pos,stop_pos,damage_mask, ammo_base)

