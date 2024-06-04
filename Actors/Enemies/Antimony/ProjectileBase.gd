class_name BaseProjectile
extends HitableCharacterBody
	
var player:Node2D          = null
var SPEED = 200

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	var dir_to_player = (player.global_position - global_position).normalized()
	velocity.x = SPEED * dir_to_player.x
	velocity.y = SPEED * dir_to_player.y
	
func _physics_process(_delta):
	var distance_to_player = player.global_position.distance_to(global_position)
	move_and_slide()
	if (distance_to_player <= 30):
		mel_attack()
func mel_attack():
	
	player.health -= get_meta("Damage")
	destroy()
func _on_timer_timeout():
	destroy()
