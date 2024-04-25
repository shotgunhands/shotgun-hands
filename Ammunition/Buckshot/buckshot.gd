extends AmmoType


# returns a list of colliders hit... for some reason lol
# ion think we need it but meh who knows right
func fire(player: CharacterBody2D, pivot: Node2D) -> Array:
	super.fire(player, pivot)
	
	var reticle = pivot.find_child("Reticle")
	var angle_offsets = get_angle_offsets()
	var state = get_viewport().world_2d.direct_space_state
	var hits = []
	for offset in angle_offsets:
		var angle = pivot.global_rotation + offset
		var target: Vector2 = reticle.global_position + Vector2.RIGHT.rotated(angle) * 6000.0
		var r_pars = PhysicsRayQueryParameters2D.create(reticle.global_position, target, 0b1_0000_0001)
		var r_info = state.intersect_ray(r_pars)
		
		var final_pos: Vector2 = Vector2.ZERO
		var parent: Node = get_tree().root
		if r_info:
			hits.append(r_info["collider"])
			if r_info["collider"].get_collision_layer_value(9):
				print("Hit an enemy!")
			else:
				final_pos = r_info["position"]
				print("Hit the environment.")
		
		_send_visual_pellet(angle, reticle.global_position, final_pos, parent)
	return hits


func _send_visual_pellet(angle: float, start_pos: Vector2, final_pos: Vector2, parent: Node):
	super._send_visual_pellet(angle, start_pos, final_pos, parent)
	
	var visual = pellet.instantiate()
	parent.add_child(visual)
	visual.global_position = start_pos
	visual.global_rotation = angle
	visual.final_pos = final_pos
	visual._start()
