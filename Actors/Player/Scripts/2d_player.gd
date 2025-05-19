class_name PlayerCharacter2D extends CharacterBody2D

@onready var movement_controller: Node2D = $MovementController
@onready var firing_controller: Node2D = $FiringController
@onready var hittable_component: Node2D = $HittableComponent

func _process(_delta):
	# ONLY FOR DEBUGGING; THIS WILL BE REPLACED
	#if Input.is_action_just_pressed("toggle_pause"):
		#Scenemanager.change_scene("main_menu")
	pass

func lose_control():
	movement_controller.lose_control()


func _on_destroy():
	get_tree().quit()