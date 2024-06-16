extends CharacterBody2D

var health = 100
@onready var movement_controller: Node2D = $MovementController
@onready var firing_controller: Node2D = $FiringController

func _physics_process( delta):
	if(health <=0):
		queue_free()

func lose_control():
	movement_controller.lose_control()
