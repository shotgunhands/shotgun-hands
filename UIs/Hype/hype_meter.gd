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
var P_drain : float = 2
var S_drain : float = 4
var A_drain : float = 5
var B_drain : float = 6

# Variables containing the amount that must be removed from the hype every second
var P_time : float
var S_time : float
var A_time : float
var B_time : float
var C_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	P_time = 100/P_drain
	S_time = 100/S_drain
	A_time = 100/A_drain
	B_time = 100/B_drain
	C_time = 0
	Scenemanager.hype_meter = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match rank:
		"P":
			hype -= P_time*delta
			if hype < 0:
				hype = 100
				rank = "S"
		"S":
			hype -= S_time*delta
			if hype < 0:
				hype = 100
				rank = "A"
		"A":
			hype -= A_time*delta
			if hype < 0:
				hype = 100
				rank = "B"
		"B":
			hype -= B_time*delta
			if hype < 0:
				hype = 100
				rank = "C"
		# Note: C is still included in case it is given a drain time of its own later on.
		"C":
			hype -= C_time*delta
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
func increase_hype(amount : float):
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



func _on_temp_increase_hype_btn_pressed():
	Scenemanager.hype_meter.increase_hype(25)
