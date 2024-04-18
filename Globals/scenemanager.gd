extends Node

var scene_library = {
	"main_menu":"res://Menus/main_menu.tscn",
	"playground":"res://Stages/Playground/playground.tscn",
	"stage_01":"",
	"stage_02":"",
	"stage_03":"",
	"stage_04":"",
	"stage_05":"",
}

var active_scene # instance of the current scene

func _ready():
	active_scene

func change_scene(scenename :String):
	active_scene
