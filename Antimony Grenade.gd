class_name enemyGrenade
extends HitableCharacterBody
	
var player:Node2D          = null

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
func _physics_process(_delta):
	move_and_slide()
func mel_attack():
	player.health -= 60
	destroy()
func _on_timer_timeout():
	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player <= 200:
		mel_attack()
	destroy()
