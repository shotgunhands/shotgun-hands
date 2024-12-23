class_name MovementProps extends Resource

@export_group("Speed and acceleration")
@export var speed = 25.0
@export var ground_acceleration = 85.0
@export var ground_deceleration = 75.0
@export var air_acceleration = 40.0
@export var air_deceleration = 20.0
@export var crouch_speed_modifier = 0.75
@export var slope_speed_multiplier: float = 5.0


@export_range(1, 10.0) var momentum_retention = 2.0
var momentum_retention_slide = 1.0

@export_group("Jump")
@export var jump_height : float = 10
@export var jump_time_to_peak : float = .4
@export var jump_time_to_descent : float = .5
@export var autohop : bool = false

var jump_vel : float
var jump_gravity : float
var fall_gravity : float

func init_jump():
	jump_vel = ((2.0 * jump_height) / jump_time_to_peak) * -1.
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.

func _scale(scale) -> void:
	speed *= scale
	ground_acceleration *= scale
	ground_deceleration *= scale
	air_acceleration *= scale
	air_deceleration *= scale
	jump_vel *= scale
	jump_gravity *= scale
	fall_gravity *= scale
	momentum_retention *= scale
	momentum_retention_slide *= scale
