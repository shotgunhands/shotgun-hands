extends CharacterBody2D

@export var movement_props: MovementProps

@onready var movement_controller: Node2D = $MovementController
@onready var firing_controller: Node2D = $FiringController

func lose_control():
	movement_controller.lose_control()


func _on_destroy():
	get_tree().quit()
