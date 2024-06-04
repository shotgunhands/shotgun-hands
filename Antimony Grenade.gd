class_name enemyGrenade
extends HitableCharacterBody
	
var player:Node2D          = null
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	global_position.y = player.global_position.y-200
	global_position.x = player.global_position.x
func _physics_process(_delta):
	move_and_slide()
	if !is_on_floor(): velocity.y += 20
func mel_attack():
	player.health -= 60
	destroy()
func _on_timer_timeout():
	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player <= 200:
		mel_attack()
	destroy()
