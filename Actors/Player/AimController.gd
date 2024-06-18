extends RigidBody2D
var buckshotScene = load("res://Actors/Player/Attacks/player_buckshot.tscn")
var cooldown = 0.5
var last_attack_time:float = 0.0
var current_time = Time.get_ticks_msec() / 1000.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	look_at(get_global_mouse_position())
	position=Vector2(0,-40)
	if current_time - last_attack_time > cooldown && Input.is_action_just_pressed("fire_left"):
		buckshot_attack()
func buckshot_attack () -> void:
	var buckshot = buckshotScene.instantiate()
	add_sibling(buckshot)
