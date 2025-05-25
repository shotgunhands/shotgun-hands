extends Control

@export var player_hold : CharacterBody2D
# health_bar, left_ammo, right_ammo and overheat_bar all contain the children of this node.

@onready var health_bar : ProgressBar = $CanvasLayer/VBoxContainer/PlayerHealth
@onready var left_ammo : RichTextLabel = $CanvasLayer/VBoxContainer/LeftHandAmmo
@onready var right_ammo : RichTextLabel = $CanvasLayer/VBoxContainer/RightHandAmmo
@onready var overheat_bar : ProgressBar = $CanvasLayer/VBoxContainer/OverheatBar

# _over_tween stores the tween being used to make the bar smooth
var _over_tween : Tween
# _waited is a variable that checks if the bar just started to reduce
var _waited : bool = true
# _over_waited is a variable that checks if overheat was just initiated
var _over_waited : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Set the text of each ammo to their gun, set the overheat bar value.
func _process(_delta):
	left_ammo.text = "Left gun ammo: " + str(player_hold.firing_controller._ammo_types[0].ammo)
	right_ammo.text = "Right gun ammo: " + str(player_hold.firing_controller._ammo_types[1].ammo)
	health_bar.value = player_hold.hittable_component.health
	health_bar.max_value = player_hold.hittable_component.MAX_HEALTH
	# Overheat bar updating
	if player_hold.firing_controller._is_overheated and _over_waited:
		# Scenario one: Just entered overheat, creates tween to take the overheat bar back to zero
		_over_waited = false
		if not _waited:
			_waited = true
			_over_tween.kill()

		_over_tween = get_tree().create_tween()
		overheat_bar.value = float(player_hold.firing_controller._overheat)
		_over_tween.tween_property(overheat_bar, "value", 0, 8)
		overheat_bar.modulate = Color(1, 0, 0)
	elif not player_hold.firing_controller._is_overheated:
		overheat_bar.modulate = Color(1, 1, 1)
		_over_waited = true
		if player_hold.firing_controller._overheat_timer.time_left < 0.7 and _waited:
			# Scenario two, outside of overheat, decriment the bar by a little bit using a tween
			_waited = false
			_over_tween = get_tree().create_tween()
			_over_tween.tween_property(overheat_bar, "value", overheat_bar.value - 1, 1)
		elif player_hold.firing_controller._overheat_timer.time_left > 0.7:
			# Scenario three, hold current value because this level of heat was just reached
			if not _waited:
				_over_tween.kill()
				_waited = true
			overheat_bar.value = float(player_hold.firing_controller._overheat)
