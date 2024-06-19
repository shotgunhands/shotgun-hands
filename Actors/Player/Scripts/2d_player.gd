extends CharacterBody2D
var health = 100
@onready var movement_controller: MovementController = $MovementController
@onready var firing_controller: FiringController = $FiringController

func _physics_process(_delta):
	if(health <=0):
		Scenemanager.change_scene("main_menu")

func lose_control():
	movement_controller.lose_control()
