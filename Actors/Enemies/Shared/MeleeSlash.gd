extends HitableCharacterBody
	
var player:Node2D          = null
@export var damage =30
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
func _physics_process(_delta):
	var distance_to_player = player.global_position.distance_to(global_position)


	move_and_slide()
	if (distance_to_player <= 60):
		mel_attack()
func mel_attack():
	
	player.health -= damage
	destroy()

func _on_timer_timeout():
	destroy()
