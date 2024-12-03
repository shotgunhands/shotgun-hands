extends Node2D

const SCALE := 10

var props: MovementProps

@onready var player = $".."

@onready var hitbox = player.find_child("Hitbox")
@onready var default_hitbox_size = hitbox.shape.size.y
@onready var default_hitbox_offset = hitbox.position.y

@onready var roof_probe = player.find_child("RoofProbe")

@onready var placeholder_sprite = player.find_child("Placeholder")
var default_placeholder_polygon = PackedVector2Array([Vector2(-12, -49),Vector2(12, -49),Vector2(12, 0),Vector2(-12, 0)])
var crouched_placeholder_polygon = PackedVector2Array([Vector2(-12, -24),Vector2(12, -24),Vector2(12, 0),Vector2(-12, 0)])

@onready var _loss_of_control_timer: Timer = $LossOfControlTimer
@onready var animated_sprite = player.find_child("AnimatedSprite")

var crouching: bool
var use_crouch_speed: float

var _control_degree: float = 1
var max_velocity_x: float

var facing_right = true


func _ready():
	props = player.movement_props

	props.init_jump()
	props._scale(SCALE)

	max_velocity_x = props.speed

func _physics_process(delta):
	_evaluate_control_degree()

	if not player.is_on_floor():
		player.velocity.y += (props.jump_gravity if player.velocity.y < 0.0 else props.fall_gravity) * delta

	if Input.is_action_just_pressed("move_jump") or (props.autohop and Input.is_action_pressed("move_jump")):
		if player.is_on_floor():
			player.velocity.y = props.jump_vel

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

	_animate()

	_evaluate_max_velocity()
	_move_horizontal(delta)

	player.move_and_slide()

func _animate():
	if player.velocity.x < 0:
		facing_right = false
	elif player.velocity.x > 0:
		facing_right = true

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

func _evaluate_control_degree():
	if _control_degree != 1:
		_control_degree = (_loss_of_control_timer.wait_time - _loss_of_control_timer.time_left) / (_loss_of_control_timer.wait_time)
		_control_degree = pow(_control_degree, 3)
		_control_degree = clampf(_control_degree, 0, 1)

func _evaluate_max_velocity():
	if max_velocity_x != props.speed or abs(player.velocity.x) < max_velocity_x:
		max_velocity_x = abs(player.velocity.x)
		max_velocity_x = max(props.speed, abs(player.velocity.x))
	if max_velocity_x > props.speed and (player.is_on_floor() and not crouching):
		max_velocity_x -= (max_velocity_x - props.speed) * _control_degree
		max_velocity_x = max(props.speed, max_velocity_x)

func _move_horizontal(delta):
	var direction = Input.get_axis("move_left", "move_right")
	var is_on_floor = player.is_on_floor()

	var deceleration = props.ground_deceleration if is_on_floor else props.air_deceleration

	var effective_max_velocity_x = max_velocity_x
	if is_on_floor and max_velocity_x == props.speed and use_crouch_speed:
		effective_max_velocity_x *= props.crouch_speed_modifier

	if direction:
		if not is_on_floor:
			player.velocity.x = move_toward(player.velocity.x, direction * effective_max_velocity_x, props.air_acceleration * delta)
		else:
			# multiplied by .01 to make the ground acceleration value more coherent to the air acceleration
			player.velocity.x = lerp(player.velocity.x, direction * effective_max_velocity_x, props.ground_acceleration * delta * .01)
		player.velocity.x = clampf(player.velocity.x, -effective_max_velocity_x, effective_max_velocity_x)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)


func lose_control():
	_control_degree = 0
	_loss_of_control_timer.start()
	max_velocity_x = abs(player.velocity.x)

func destroy():
	Scenemanager.change_scene("main_menu")
