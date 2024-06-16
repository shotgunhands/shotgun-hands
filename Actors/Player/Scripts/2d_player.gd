extends CharacterBody2D

@onready var movement_controller: MovementController = $MovementController
@onready var firing_controller: FiringController = $FiringController

func lose_control():
	movement_controller.lose_control()
