extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScrollContainer/TabContainer.current_tab = randi_range(0, $ScrollContainer/TabContainer.get_child_count())
	for item in $ScrollContainer/TabContainer.get_children():
		item.connect("meta_clicked", meta_clicked)

func meta_clicked(meta):
	OS.shell_open(meta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_jump"):
		if randf_range(0, 1) > 0.5:
			$ScrollContainer/TabContainer.current_tab = randi_range(0, $ScrollContainer/TabContainer.get_child_count())
		else:
			$ScrollContainer/TabContainer.current_tab += 1
