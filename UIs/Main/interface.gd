extends Control

@export var player_hold : CharacterBody2D
@onready var health_bar : ProgressBar = $CanvasLayer/VBoxContainer/PlayerHealth
@onready var left_ammo : RichTextLabel = $CanvasLayer/VBoxContainer/LeftHandAmmo
@onready var right_ammo : RichTextLabel = $CanvasLayer/VBoxContainer/RightHandAmmo
@onready var overheat_bar : ProgressBar = $CanvasLayer/VBoxContainer/OverheatBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	left_ammo.text = "Left gun ammo: " + str(player_hold.firing_controller._ammo_types[0].ammo)
	right_ammo.text = "Right gun ammo: " + str(player_hold.firing_controller._ammo_types[1].ammo)
	overheat_bar.value = player_hold.firing_controller._overheat
	

