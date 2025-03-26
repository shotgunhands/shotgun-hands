class_name EnviroHazard extends Area2D

@export
var damage : int
@export
var launch_vel : int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	launch_vel *= -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass




func _on_area_entered(area: Area2D) -> void:
	print("I know what I'm doing")
	print(area)
	if area is HittableComponent:
		area.hurt(damage)
		if area.get_parent() is PlayerCharacter2D:
			area.get_parent().movement_controller.jumping = true
			area.get_parent().velocity.y = launch_vel
			print(area.get_parent().movement_controller.player.velocity.y)
			area.get_parent().movement_controller.animated_sprite.play("jump")
