extends AmmoType


func fire(player: CharacterBody2D, pivot: Node2D) -> Array:
	super.fire(player, pivot)
	
	var hits = []
	var angle = pivot.global_rotation
	var reticle = pivot.find_child("Reticle")
	var target = reticle.global_position + Vector2.RIGHT.rotated(angle) * 6000.0
	var r_info = _cast_ray(reticle.global_position, target)
		
	var final_pellet_pos = Vector2.ZERO
	var parent: Node = get_tree().root
	if r_info:
		hits.append(r_info["collider"])
		if r_info["collider"].get_collision_layer_value(9):
			print("Hit an enemy!")
		else:
			final_pellet_pos = r_info["position"]
			print("Hit the environment.")
	_send_visual_pellet(angle, reticle.global_position, final_pellet_pos, parent)
	return hits


func _send_visual_pellet(angle: float, start_pos: Vector2, final_pos: Vector2, parent: Node):
	super._send_visual_pellet(angle, start_pos, final_pos, parent)
	
	var visual = _pellet.instantiate()
	parent.add_child(visual)
	visual.global_position = start_pos
	visual.global_rotation = angle
	visual.final_pos = final_pos
	visual._start()
