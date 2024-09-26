extends CharacterBody2D

@onready var movement_controller: Node2D = $MovementController
@onready var firing_controller: Node2D = $FiringController

func _process(_delta):
	# ONLY FOR DEBUGGING; THIS WILL BE REPLACED
	if Input.is_action_just_pressed("toggle_pause"):
		Scenemanager.change_scene("main_menu")

func lose_control():
	movement_controller.lose_control()
