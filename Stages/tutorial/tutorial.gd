extends Node2D

# The purpose of this script is to set up some things for the tutorial
# (such as joseph having less ammo than normal and only being able to reload when the prompt appears)

@export
var player : CharacterBody2D

var can_shoot : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.firing_controller._ammo_types[0].ammo = 0
	player.firing_controller._ammo_types[1].ammo = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#player.movement_controller.jumping = true
	
	if can_shoot == 0:
		player.firing_controller._ammo_types[0].ammo = 0
		player.firing_controller._ammo_types[1].ammo = 0
	elif can_shoot == 1:
		if Input.is_action_just_pressed("fire_left"):
			player.firing_controller._ammo_types[1].ammo = 1
			$shootorial1.hide()
			$shootorial2.show()
			var tween = get_tree().create_tween()
			tween.tween_property($shootorial2, "position", $shootorial2.position + Vector2(0, 20), 0.5)
			can_shoot = 2
	elif can_shoot == 2:
		if Input.is_action_just_pressed("fire_right"):
			player.firing_controller._ammo_types[0].ammo = 1
			player.firing_controller._ammo_types[1].ammo = 1
			$shootorial2.hide()
			$shootorial3.show()
			var tween = get_tree().create_tween()
			tween.tween_property($shootorial3, "position", $shootorial3.position + Vector2(0, 20), 0.5)
			can_shoot = 3
	elif can_shoot == 3 or can_shoot == 4:
		if Input.is_action_just_pressed("fire_right"):
			can_shoot += 1
		if Input.is_action_just_pressed("fire_left"):
			can_shoot += 1
		if can_shoot >= 5:
			$shootorial3.hide()
			var tween = get_tree().create_tween()
			tween.tween_property($wall2, "position", $wall2.position + Vector2(0, -100), 0.5)



func _on_shoot_trigger_body_entered(body: Node2D) -> void:
	if can_shoot == 0 and body is PlayerCharacter2D:
		print("entered")
		print(body)
		player.firing_controller._ammo_types[0].ammo = 1
		player.firing_controller._ammo_types[1].ammo = 0
		can_shoot = 1
		$shootorial1.show()
		var tween = get_tree().create_tween()
		tween.tween_property($shootorial1, "position", $shootorial1.position + Vector2(0, 20), 0.5)
