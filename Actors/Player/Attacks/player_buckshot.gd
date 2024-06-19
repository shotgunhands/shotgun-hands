extends RigidBody2D
@export var SPEED = 50
var pivot
func _ready():

	pivot = get_tree().get_nodes_in_group("pivot")[0]
	rotation=pivot.rotation
	position=pivot.position
	constant_force  = Vector2(1, 0).rotated(rotation) * SPEED
func _physics_process(_delta):
	pass
func _on_timer_timeout():
	queue_free()
