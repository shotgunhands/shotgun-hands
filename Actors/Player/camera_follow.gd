extends Camera2D

@onready var player = $"../2DPlayer"

func _ready():
	pass # Replace with function body.


func _process(delta):
	global_position.x = player.global_position.x
