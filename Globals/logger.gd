extends Node

var to_file = true
var logging_enabled = true

func _ready():
	# TODO File Writing
	pass

func log(content):
	if not logging_enabled:
		return
	print(content)
	Console.cast_message(content)

