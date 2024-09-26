class_name HypeMeter extends Control

# The current level of hype from 1-100
var hype : float = 0
# The current rank of the player from C-A as well as S and P
var rank : String = "C"

# Variables containing the node children for easy access
@onready var rank_label : RichTextLabel = $VBoxContainer/HypeLabel
@onready var hype_bar : ProgressBar = $VBoxContainer/HypeBar

# Variables containing the time in seconds that each rank will take to fully drain
# C is not included since it doesn't drain
var _p_drain : float = 2
var _s_drain : float = 4
var _a_drain : float = 5
var _b_drain : float = 6

# Variables containing the amount that must be removed from the hype every second
var _p_time : float
var _s_time : float
var _a_time : float
var _b_time : float
var _c_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	# Sets the amount each rank should drain in a second.
	_p_time = 100/_p_drain
	_s_time = 100/_s_drain
	_a_time = 100/_a_drain
	_b_time = 100/_b_drain
	_c_time = 0
	Scenemanager.hype_meter = self


func _process(delta):
	# Using the switch statement, determine how fast the hype should be draining
	match rank:
		"P":
			hype -= _p_time*delta
			if hype < 0:
				hype = 100
				rank = "S"
		"S":
			hype -= _s_time*delta
			if hype < 0:
				hype = 100
				rank = "A"
		"A":
			hype -= _a_time*delta
			if hype < 0:
				hype = 100
				rank = "B"
		"B":
			hype -= _b_time*delta
			if hype < 0:
				hype = 100
				rank = "C"
		# Note: C is still included in case it is given a drain time of its own later on.
		"C":
			hype -= _c_time*delta
			if hype < 0:
				hype = 0
		"F":
			hype = 0
		_:
			rank = "C"
	
	rank_label.text = rank
	hype_bar.value = hype


# Increases the hype amount and increases the rank if it must
# This funciton can be called globally using the scene manager
# by typing `Scenemanager.hype_meter.increase_hype(amount)`
func _increase_hype(amount : float) -> void:
	hype += amount
	while hype > 100:
		hype -= 100
		match rank:
			"P":
				hype = 100
				break
			"S":
				rank = "P"
			"A":
				rank = "S"
			"B":
				rank = "A"
			"C":
				rank = "B"
			_:
				rank = "C"



# Feel free to remove this, it's just a temporary thing until actual hype increases are implemented.
func _on_temp_increase_hype_btn_pressed():
	Scenemanager.hype_meter._increase_hype(25)
