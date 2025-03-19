extends Node2D

# The purpose of this script is to set up some things for the tutorial
# (such as joseph having less ammo than normal and only being able to reload when the prompt appears)

@export
var player : CharacterBody2D

var can_shoot : int = 0

var shot_jump : int = 0

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
	if player.firing_controller._is_overheated and not $Label9.visible and $Label6.visible:
		$Label9.show()
		var tween = get_tree().create_tween()
		tween.tween_property($Label9, "position", $Label9.position + Vector2(0, 20), 0.5)



func _on_shoot_trigger_body_entered(body: Node2D) -> void:
	if can_shoot == 0 and body is PlayerCharacter2D:
		player.firing_controller._ammo_types[0].ammo = 1
		player.firing_controller._ammo_types[1].ammo = 0
		can_shoot = 1
		$shootorial1.show()
		var tween = get_tree().create_tween()
		tween.tween_property($shootorial1, "position", $shootorial1.position + Vector2(0, 20), 0.5)





func _on_sjump_trigger_body_entered(body: Node2D) -> void:
	if shot_jump == 0 and body is PlayerCharacter2D:
		shot_jump = 1
		var tween = get_tree().create_tween()
		$Label3.show()
		tween.tween_property($Label3, "position", $Label3.position + Vector2(0, 20), 0.5)
	elif shot_jump == 2 and body is PlayerCharacter2D:
		shot_jump = 3
		var tween = get_tree().create_tween()
		$Label2.show()
		tween.tween_property($Label2, "position", $Label2.position + Vector2(0, 20), 0.5)


func _on_enviro_hazard_area_entered(area: Area2D) -> void:
	if area is HittableComponent and shot_jump == 1:
		shot_jump = 2


func _on_dummy_destroy() -> void:
	if player.firing_controller._is_overheated:
		var tween = get_tree().create_tween()
		tween.tween_property($wall3, "position", $wall3.position + Vector2(0, -100), 0.5)
	else:
		if not $Label6.visible:
			$Label10.hide()
			$Label6.show()
			var tween = get_tree().create_tween()
			tween.tween_property($Label6, "position", $Label6.position + Vector2(0, 20), 0.5)
