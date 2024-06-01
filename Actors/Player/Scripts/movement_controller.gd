extends Node2D

@export_range(1.0, 100.0) var speed = 10.0
var crouch_speed_modifier = 0.75
@export_range(1.0, 50.0) var jump_power = 20.0

@export_range(1, 10.0) var momentum_retention = 2.0
var momentum_retention_slide = 1.0

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export_range(0, 50.0) var gravity = 9.81
const SCALE = 10

@onready var player = $".."

@onready var hitbox = player.find_child("Hitbox")
var default_hitbox_size
var default_hitbox_offset
@onready var roof_probe = player.find_child("RoofProbe")

@onready var debug_health_label = player.find_child("DebugHealthLabel")

@onready var placeholder_sprite = player.find_child("Placeholder")
var default_placeholder_polygon = PackedVector2Array([Vector2(-12, -49),Vector2(12, -49),Vector2(12, 0),Vector2(-12, 0)])
var crouched_placeholder_polygon = PackedVector2Array([Vector2(-12, -24),Vector2(12, -24),Vector2(12, 0),Vector2(-12, 0)])
var crouching
var use_crouch_speed

@onready var _loss_of_control_timer: Timer = $LossOfControlTimer
var _control_degree: float = 1
var max_velocity_x: float

var facing_right = true

@onready var animated_sprite = player.find_child("AnimatedSprite")


func _ready():
	default_hitbox_size = hitbox.shape.size.y
	default_hitbox_offset = hitbox.position.y
	speed *= SCALE
	jump_power *= SCALE
	gravity *= SCALE
	momentum_retention *= SCALE
	momentum_retention_slide *= SCALE

	max_velocity_x = speed


func _process(_delta):
	# ONLY FOR DEBUGGING; THIS WILL BE REPLACED
	if Input.is_action_just_pressed("toggle_pause"):
		Scenemanager.change_scene("main_menu")

func _physics_process(delta):
	_evaluate_control_degree()

	# Apply gravity.
	if not player.is_on_floor():
		player.velocity.y += gravity * delta # no delta mb, we're in phys_process

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and player.is_on_floor():
		player.velocity.y -= jump_power

	# Handle crouching.
	if Input.is_action_pressed("move_crouch") and player.is_on_floor():
		crouching = true
		use_crouch_speed = true
	else:
		crouching = false

	if crouching:
		hitbox.shape.size.y = default_hitbox_size / 2
		hitbox.position.y = default_hitbox_offset / 2
		placeholder_sprite.polygon = crouched_placeholder_polygon
	else:
		if not roof_probe.is_colliding():
			hitbox.shape.size.y = default_hitbox_size
			hitbox.position.y = default_hitbox_offset
			placeholder_sprite.polygon = default_placeholder_polygon
			use_crouch_speed = false

	#debug_health_label.text = "({hp}%)\n{pos}".format({"hp": health_perc(), "pos": player.global_position})
	debug_health_label.text = "({hp}%)\n{pos}".format({"pos": player.global_position})

	if player.velocity.x < 0:
		facing_right = false
	elif player.velocity.x > 0:
		facing_right = true
	else:
		facing_right = facing_right

	animated_sprite.flip_h = !facing_right

	if player.is_on_floor():
		if player.velocity.length() > 1:
			if use_crouch_speed:
				if not animated_sprite.animation == "crouch":
					animated_sprite.play("crouch")
			else:
				if not animated_sprite.animation == "run":
					animated_sprite.play("run")
		else:
			if not use_crouch_speed:
				if not animated_sprite.animation == "idle":
					animated_sprite.play("idle")
			else:
				if not animated_sprite.animation == "crouch":
					animated_sprite.play("crouch")
	else:
		if not animated_sprite.animation == "jump":
			animated_sprite.play("jump")

	_evaluate_max_velocity()
	_move_horizontal()

	player.move_and_slide()


func _evaluate_control_degree():
	if _control_degree != 1:
		_control_degree = (_loss_of_control_timer.wait_time - _loss_of_control_timer.time_left) / (_loss_of_control_timer.wait_time)
		_control_degree = pow(_control_degree, 3)
		_control_degree = clampf(_control_degree, 0, 1)


# checks state, returns what the value of max_velocity should be
func _evaluate_max_velocity():
	if max_velocity_x != speed or abs(player.velocity.x) < max_velocity_x:
		max_velocity_x = abs(player.velocity.x)
		max_velocity_x = max(speed, abs(player.velocity.x))
	if max_velocity_x > speed and (player.is_on_floor() and not crouching):
		max_velocity_x -= (max_velocity_x - speed) * _control_degree
		max_velocity_x = max(speed, max_velocity_x)


func _move_horizontal():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		player.velocity.x += direction * speed * _control_degree
		player.velocity.x = clampf(player.velocity.x, -max_velocity_x, max_velocity_x)
		if player.is_on_floor() and max_velocity_x == speed:
			# other stuff potentially
			if use_crouch_speed:
				player.velocity.x *= crouch_speed_modifier
	else:
		if not crouching:
			player.velocity.x = move_toward(player.velocity.x, 0, (momentum_retention * _control_degree))
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, (momentum_retention_slide * _control_degree))


func lose_control():
	_control_degree = 0
	_loss_of_control_timer.start()
	max_velocity_x = abs(player.velocity.x)

func destroy():
	Scenemanager.change_scene("main_menu")
