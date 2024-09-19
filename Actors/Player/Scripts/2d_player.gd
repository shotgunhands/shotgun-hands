class_name PlayerCharacter2D extends CharacterBody2D

@onready var movement_controller: Node2D = $MovementController
@onready var firing_controller: Node2D = $FiringController
@onready var hittable_component: Node2D = $HittableComponent

func _process(_delta):
	pass

func lose_control():
	movement_controller.lose_control()


func _on_destroy():
	get_tree().quit()
	
