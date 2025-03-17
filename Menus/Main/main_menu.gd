class_name MainMenu extends Node

@onready var play_btn: Button = $Center/VBox/Play
@onready var quit_btn: Button = $Center/VBox/Quit

@onready var start_menu : CenterContainer = $Center
@onready var level_select_menu : ScrollContainer = $LevelSel

var selected_level = "stage_01"

func _ready() -> void:
	_connect_signals()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_pause"):
		_on_return()

func _on_play():
	#Scenemanager.change_scene("stage_01")
	start_menu.hide()
	level_select_menu.show()

func _on_quit():
	get_tree().quit()

func _connect_signals():
	play_btn.pressed.connect(_on_play)
	quit_btn.pressed.connect(_on_quit)

func _on_return():
	if level_select_menu.visible:
		start_menu.show()
		level_select_menu.hide()


func _on_level_selected(level: String) -> void:
	selected_level = level
	level_select_menu.hide()
