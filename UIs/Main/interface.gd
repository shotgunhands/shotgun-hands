extends Control

# player_hold is a variable containing the player
@export var player_hold : CharacterBody2D
# health_bar, left_ammo, right_ammo and overheat_bar all contain the children of this node.
@onready var health_bar : ProgressBar = $CanvasLayer/VBoxContainer/PlayerHealth
@onready var left_ammo : RichTextLabel = $CanvasLayer/VBoxContainer/LeftHandAmmo
@onready var right_ammo : RichTextLabel = $CanvasLayer/VBoxContainer/RightHandAmmo
@onready var overheat_bar : ProgressBar = $CanvasLayer/VBoxContainer/OverheatBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Set the text of each ammo to their gun, set the overheat bar value.
func _process(_delta):
	var healthObject: HittableComponent = player_hold.find_child("HittableComponent")
	health_bar.value = healthObject.get_health_perc()
	left_ammo.text = "Left gun ammo: " + str(player_hold.firing_controller._ammo_types[0].ammo)
	right_ammo.text = "Right gun ammo: " + str(player_hold.firing_controller._ammo_types[1].ammo)
	overheat_bar.value = player_hold.firing_controller._overheat
	

