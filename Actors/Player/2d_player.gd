extends CharacterBody2D

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

@onready var placeholder_sprite = $Placeholder
var default_placeholder_polygon = PackedVector2Array([Vector2(-12, -49),Vector2(12, -49),Vector2(12, 0),Vector2(-12, 0)])
var crouched_placeholder_polygon = PackedVector2Array([Vector2(-12, -24),Vector2(12, -24),Vector2(12, 0),Vector2(-12, 0)])
var crouching

func _ready():
	default_hitbox_size = hitbox.shape.size.y
	default_hitbox_offset = hitbox.position.y
	speed *= SCALE
	jump_power *= SCALE
	gravity *= SCALE
	momentum_retention *= SCALE
	momentum_retention_slide *= SCALE

func _physics_process(delta):
	# Apply gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y -= jump_power
	
	# Handle crouching.
	var use_crouch_speed
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
	
	# Move horizontally according to input.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if not crouching:
			velocity.x = direction * speed
		else:
			velocity.x = direction * (speed * crouch_speed_modifier)
	else:
		if not crouching:
			velocity.x = move_toward(velocity.x, 0, speed/momentum_retention)
		else:
			velocity.x = move_toward(velocity.x, 0, speed/momentum_retention_slide)

	move_and_slide()
