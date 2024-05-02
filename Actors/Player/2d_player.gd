extends HitableCharacterBody

@export_range(1.0, 100.0) var speed = 10.0
var crouch_speed_modifier = 0.75
@export_range(1.0, 50.0) var jump_power = 20.0

@export_range(1, 10.0) var momentum_retention = 2.0
var momentum_retention_slide = 1.0

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export_range(0, 50.0) var gravity = 9.81
const SCALE = 10

@onready var hitbox = $Hitbox
var default_hitbox_size
var default_hitbox_offset
@onready var roof_probe = $RoofProbe

@onready var debug_health_label = $DebugHealthLabel

@onready var placeholder_sprite = $Placeholder
var default_placeholder_polygon = PackedVector2Array([Vector2(-12, -49),Vector2(12, -49),Vector2(12, 0),Vector2(-12, 0)])
var crouched_placeholder_polygon = PackedVector2Array([Vector2(-12, -24),Vector2(12, -24),Vector2(12, 0),Vector2(-12, 0)])
var crouching
var use_crouch_speed

var facing_right = true

@onready var animated_sprite = $AnimatedSprite
@onready var aimline = $Aimline


func _ready():
	INIT_HEALTH = 100
	MAX_HEALTH = 100

	health = INIT_HEALTH

	default_hitbox_size = hitbox.shape.size.y
	default_hitbox_offset = hitbox.position.y
	speed *= SCALE
	jump_power *= SCALE
	gravity *= SCALE
	momentum_retention *= SCALE
	momentum_retention_slide *= SCALE

func _process(_delta):
	# ONLY FOR DEBUGGING; THIS WILL BE REPLACED
	if Input.is_action_just_pressed("toggle_pause"):
		Scenemanager.change_scene("main_menu")

func _physics_process(delta):
	# Handle crouching.
	if Input.is_action_pressed("move_crouch"):
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

	# Apply gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y -= jump_power

	debug_health_label.text = "({hp}%)\n{pos}".format({"hp": health_perc(), "pos": global_position})

	# Move horizontally according to input.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if not use_crouch_speed:
			velocity.x = direction * speed
		else:
			velocity.x = direction * (speed * crouch_speed_modifier)
	else:
		if not use_crouch_speed:
			velocity.x = move_toward(velocity.x, 0, speed/momentum_retention)
		else:
			velocity.x = move_toward(velocity.x, 0, speed/momentum_retention_slide)

	if velocity.x < 0:
		facing_right = false
	elif velocity.x > 0:
		facing_right = true
	else:
		facing_right = facing_right

	var aimline_root = position + Vector2(0, -25)
	var _aimline_point = (get_global_mouse_position() - aimline_root).normalized()
	aimline.rotation = aimline_root.angle_to_point(get_global_mouse_position())

	animated_sprite.flip_h = !facing_right

	if is_on_floor():
		if velocity.length() > 1:
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

	move_and_slide()

func destroy():
	Scenemanager.change_scene("main_menu")
