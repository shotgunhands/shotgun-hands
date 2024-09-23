extends CharacterBody2D

@onready var movement_controller: Node2D = $MovementController
@onready var firing_controller: Node2D = $FiringController

func _process(_delta):
	pass

func lose_control():
	movement_controller.lose_control()


func _on_hittable_component_destroy():
	print("dead")
	Scenemanager.change_scene("main_menu")
