extends Area2D

@export
var controller : CutscenePlayer
@export
var animation_name : String

var allowed : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass




func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter2D and allowed:
		controller.start_cut_scene(animation_name)
		allowed = false
