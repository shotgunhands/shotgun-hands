extends CanvasLayer

### VARIABLES ###
@onready var __input:LineEdit = %LineEdit
@onready var _output:RichTextLabel = %RichTextLabel

var _history: Array[String] = [""]

### METHODS ###
func _ready() -> void:
	__input.gui_input.connect(_on_input)
	clear()
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_dev_console_toggle"):
		visible = !visible

func _on_input(event:InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_UP and event.pressed:
			__input.text = _history[0]
		if event.keycode == KEY_ENTER and event.pressed:
			if event is InputEventWithModifiers and not event.shift_pressed:
				var expression:Expression = Expression.new()

				_history.push_front(__input.text)

				var parse_error = expression.parse(__input.text)
				if parse_error != OK:
					cast_message("[color=red]"+expression.get_error_text()+"[/color]")

				var execute_result = expression.execute([], self)
				if expression.has_execute_failed():
					cast_message("[color=red]"+expression.get_error_text()+"[/color]")
				elif execute_result != null:
					if not execute_result is Object:
						_output.text += String(execute_result) + '\n'


				__input.text = ""

### COMMANDS ###
func cast_message(msg:String) -> void: _output.text += msg + '\n'

func clear()->void: _output.text = ""

func get_history()->void:
	for i in _history:
		cast_message(i)

