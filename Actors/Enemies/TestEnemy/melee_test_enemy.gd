extends BaseEnemyBehaviour
class_name MeleeTestEnemy

func _idle_logic() -> void:
	velocity.x = 50
	
	move_and_slide()
