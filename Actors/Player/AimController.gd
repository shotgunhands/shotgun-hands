extends RigidBody2D
var buckshotScene = load("res://Actors/Player/Attacks/player_buckshot.tscn")
var slugScene = load("res://Actors/Player/Attacks/player_slug.tscn")
var cooldown = 1
var last_attack_time:float = 0.0
var current_time = Time.get_ticks_msec() / 1000.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	look_at(get_global_mouse_position())
	position=Vector2(0,-40)
	if current_time - last_attack_time > cooldown && Input.is_action_just_pressed("fire_left"):
		last_attack_time=current_time
		buckshot_attack()
	if current_time - last_attack_time > cooldown && Input.is_action_just_pressed("fire_right"):
		slug_attack()
		last_attack_time=current_time
	if Input.is_action_just_pressed("fire_reload"):
		last_attack_time=0
func buckshot_attack () -> void:
	var buckshot = buckshotScene.instantiate()
	add_sibling(buckshot)
func slug_attack () -> void:
	var slug = slugScene.instantiate()
	add_sibling(slug)
