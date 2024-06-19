extends Area2D
var player:Node2D          = null
@export var health =100
signal dieFather
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if health <=0:
		dieFather.emit()





func _on_body_entered(body: Node2D):
	print("hrgre")
	if body.is_in_group("bullet"):
		body.queue_free()
		health=health-10
