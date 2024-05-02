class_name BaseEnemy
extends HitableCharacterBody

### CONSTANTS ###
@export var MEL_ATTACK_RANGE = 100
@export var SPEED = 200
@export var GRAVITY = 20
@export var JUMP_SPEED = -500

### VARIABLES ###
var has_seen: bool = false;
var direction = 1
var player = null

### REFERENCES ###
@onready var anim_player:AnimationPlayer = $AnimationPlayer

### METHODS ###
func _ready():
	super()
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta) -> void:
	if kill_check(): return

	if !is_on_floor(): velocity.y += GRAVITY

	move_logic(delta)
	attack_logic()
	move_and_slide()

func move_logic(_delta:float) -> void:
	if anim_player.is_playing(): return

	if is_on_wall(): direction *= -1

	if check_can_see(): has_seen = true

	if has_seen:
		var dir_to_player = (player.global_position - global_position).normalized()
		velocity.x = SPEED * dir_to_player.x
	else:
		velocity.x = SPEED * direction

func attack_logic() -> void:
	if anim_player.current_animation == "ATK" && anim_player.is_playing(): return

	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player <= MEL_ATTACK_RANGE:
		anim_player.play("ATK")
		mel_attack()

func check_can_see() -> bool:
	var space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

	var from: Vector2 = global_transform.origin
	var to: Vector2 = player.global_transform.origin

	from.y -= 45

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result = space_state.intersect_ray(query)

	return result["collider"].is_in_group("Player") if !result.is_empty() && result["collider"] != null else false

func mel_attack() -> void:
	player.health -= 10
