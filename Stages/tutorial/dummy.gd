extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hittable_component_destroy() -> void:
	var roTween : Tween = get_tree().create_tween()
	roTween.tween_property(self, "rotation", deg_to_rad(90), 0.1)
	roTween.tween_property($HittableComponent, "health", $HittableComponent.MAX_HEALTH, 2)
	roTween.tween_property(self, "rotation", deg_to_rad(0), 0.5)
