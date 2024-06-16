extends CharacterBody2D
var health = 100
@onready var movement_controller: MovementController = $MovementController
@onready var firing_controller: FiringController = $FiringController
func _physics_process(delta):
	if(health <=0):
		get_tree().change_scene("res://Menus/Main/MainMenu.tscn")
func lose_control():
	movement_controller.lose_control()
