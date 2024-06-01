class_name HittableComponent
extends Area2D

@export var MAX_HEALTH: float = 100.0
@export var INIT_HEALTH: float = 100.0

var _health: float
var health: float = 100: set = set_health, get = get_health # The health you **ACTUALLY** access

@onready var parent: Node2D = $".."

func _ready() -> void:
	_health = INIT_HEALTH


func get_health_perc() -> int:
	return round(100 * _health / MAX_HEALTH)


func kill_check() -> bool:
	if _health <= 0:
		destroy()
		return true
	return false


func set_health(value: float) -> void:
	_health = min(value, MAX_HEALTH)
	kill_check()


func get_health() -> float:
	return _health


func destroy() -> void:
	parent.queue_free()
