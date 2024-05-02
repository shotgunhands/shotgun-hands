extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_dev_console_toggle") && OS.is_debug_build():
		Console.visible = !Console.visible


# func _ready():
# 	pass

# func _process(delta):
# 	pass
