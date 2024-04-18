extends Node

var to_file = true
var logging_enabled = false

func _ready():
	# TODO File Writing
	pass 

func log(content, color = "white"):
	if not logging_enabled:
		return
	
	print_rich("[color=" + color + "]")
	print_rich(content)
	print_rich("[/color]")
