class_name CutscenePlayer extends AnimationPlayer

@export
var externalcam : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_playing():
		$CutsceneCam.position = externalcam.position


func start_cut_scene(cutscenename) -> void:
	get_tree().paused = true
	play(cutscenename)
	$CutsceneCam.enabled = true
	$CutsceneCam.make_current()


func _on_animation_finished(_anim_name: StringName) -> void:
	get_tree().paused = false
	$CutsceneCam.enabled = false
