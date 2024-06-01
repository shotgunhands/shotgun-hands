extends Camera2D

@export var velCChangeMul: float = 0.258

@onready var player = $"../2DPlayer"

func _process(_delta) -> void:
	global_position.x = player.global_position.x + (player.velocity.x * velCChangeMul)
