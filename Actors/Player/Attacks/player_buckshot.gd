extends CharacterBody2D
var SPEED = 200
var pivot
func _ready():

	pivot = get_tree().get_nodes_in_group("pivot")[0]
	rotation=pivot.rotation
	position=pivot.position
	velocity = Vector2(1, 0).rotated(rotation) * SPEED
func _physics_process(_delta):
	move_and_slide()
func mel_attack():
	queue_free()
func _on_timer_timeout():
	queue_free()
