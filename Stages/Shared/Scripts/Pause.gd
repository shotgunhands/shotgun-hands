extends CanvasLayer
@onready var quit_btn: Button = $Center/VBox/Quit
@onready var cont_btn: Button = $Center/VBox/Continue
@onready var center := $Center
func _process(_delta):
		if Input.is_action_just_pressed("toggle_pause"):
			_toggle()
func _toggle() -> void:
	var tree := get_tree()
	if tree.paused:
		center.hide()
		tree.paused = false
		
	else:
		center.show()
		tree.paused = true
func _ready() -> void:
	quit_btn.pressed.connect(_on_quit)
	cont_btn.pressed.connect(_toggle)
func _on_quit():
	get_tree().quit()
