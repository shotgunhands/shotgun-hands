extends HitableCharacterBody

@onready var movement_controller: Node2D = $MovementController
@onready var firing_controller: Node2D = $FiringController

func lose_control():
	movement_controller.lose_control()
