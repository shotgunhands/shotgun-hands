class_name MainMenu extends Node

@onready var play_btn: Button = $Center/VBox/Play
@onready var quit_btn: Button = $Center/VBox/Quit

func _ready() -> void:
	_connect_signals()

func _on_play():
	Scenemanager.change_scene("stage_01")
	
func _on_quit():
	get_tree().quit()

func _connect_signals():
	play_btn.pressed.connect(_on_play)
	quit_btn.pressed.connect(_on_quit)
