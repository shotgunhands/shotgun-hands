extends RichTextLabel

var username = "ERROR: PLAYER HAS NO USERNAME. IDIOT"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	text = "[center]hello " + username + " :)"
