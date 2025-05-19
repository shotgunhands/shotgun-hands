extends AmmoType


func fire(shoot_angle:float, shoot_position: Vector2, damage_mask:int):
	super.fire(shoot_angle, shoot_position, damage_mask)


func _send_visual_pellet(angle: float, start_pos: Vector2, ammo_base: AmmoType):
	var visual = super._send_visual_pellet(angle, start_pos,ammo_base)
	visual.innacuracy = 2