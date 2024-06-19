extends Node

var scene_library := {
	"main_menu":"res://Menus/Main/main_menu.tscn",
	"playground":"res://Stages/Playground/playground.tscn",
	"stage_01":"res://Stages/Streets/Level1/Streets level 1.tscn",
	"stage_02":"",
	"stage_03":"",
	"stage_04":"",
	"stage_05":"",
}

var active_scene # instance of the current scene

var hype_meter : Control # Contains the hype meter object for quick reference

func _ready():
	active_scene = $"/root/MainMenu" # set the main menu as the active scene

# load scene by name
func change_scene(scenename :String):
	var loaded_new_scene = load(scene_library[scenename])
	var new_scene = loaded_new_scene.instantiate()
	$"/root".add_child(new_scene)
	$"/root".remove_child(active_scene)
	active_scene.queue_free()
	active_scene = new_scene

# add a scene to the registry at runtime, will overwrite existing scenes
func register_scene(scenename :String, scenepath :String):
	scene_library[scenename] = scenepath
