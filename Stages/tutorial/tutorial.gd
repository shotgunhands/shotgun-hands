extends Node2D

# The purpose of this script is to set up some things for the tutorial
# (such as joseph having less ammo than normal and only being able to reload when the prompt appears)

@export
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.firing_controller._ammo_types[0].ammo = 1
	player.firing_controller._ammo_types[1].ammo = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player.movement_controller.jumping = true
