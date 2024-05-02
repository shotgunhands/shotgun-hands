class_name HitableCharacterBody
extends CharacterBody2D

@export var MAX_HEALTH: float = 100.0
@export var INIT_HEALTH: float = 100.0

var _health: float

func _ready() -> void:
	_health = INIT_HEALTH

func health_perc() -> int:
	return round(100 * _health / MAX_HEALTH)

func destroy() -> void:
	queue_free()

func kill_check() -> void:
	if _health <= 0:
		destroy()

func set_health(value: float) -> void:
	_health = min(value, MAX_HEALTH)
	kill_check()

func get_health() -> float:
	return _health

var health: float = 100: set = set_health, get = get_health
