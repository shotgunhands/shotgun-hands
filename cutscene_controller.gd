class_name CutscenePlayer extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_cut_scene(cutscenename) -> void:
	get_tree().paused = true
	play(cutscenename)


func _on_animation_finished(anim_name: StringName) -> void:
	get_tree().paused = false
