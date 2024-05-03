extends CanvasLayer

### VARIABLES ###
@onready var _input_line: LineEdit = %LineEdit
@onready var _output_label: RichTextLabel = %RichTextLabel

var _history: Array[String] = [""]

### METHODS ###
func _ready() -> void:
	_input_line.gui_input.connect(_on_input)
	visible = false
	clear()

func _on_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_UP and event.pressed:
			_input_line.text = _history[0]
		if event.keycode == KEY_ENTER and event.pressed:
			if event is InputEventWithModifiers and not event.shift_pressed:
				var expression: Expression = Expression.new()

				_history.push_front(_input_line.text)

				var parse_error = expression.parse(_input_line.text)
				if parse_error != OK:
					cast_message("[color=red]" + expression.get_error_text() + "[/color]")

				var execute_result = expression.execute([], self)
				if expression.has_execute_failed():
					cast_message("[color=red]" + expression.get_error_text() + "[/color]")
				elif execute_result != null:
					if not execute_result is Object:
						_output_label.text += String(execute_result) + '\n'

				_input_line.text = ""

### COMMANDS ###
func cast_message(msg: String) -> void:
	_output_label.text += msg + '\n'

func clear() -> void:
	_output_label.text = ""

func get_history() -> void:
	for i in _history:
		cast_message(i)
