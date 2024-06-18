extends CharacterBody2D
var health = 100
@onready var movement_controller: MovementController = $MovementController
func _physics_process(_delta):
	if(health <=0):
		get_tree().quit()
func lose_control():
	movement_controller.lose_control()
