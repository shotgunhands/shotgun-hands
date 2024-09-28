extends BaseEnemyBehaviour
class_name MeleeTestEnemy

@export var _direction: int = 1
@export var _run_speed: float = 5
var _player_in_range: bool = false

func _on_destroy() -> void:
	queue_free()
@export var _hurtbox: Area2D
@export var _debug_visual_hurtbox: Polygon2D
@export var _debug_visual_enemy: Polygon2D
@export var _idle_color: Color
@export var _chase_color: Color
@export var _attack_color: Color
@export var _hit_damage: float

@onready var _windup_timer: Timer = $"AttackTimers/WindupTimer"
@onready var _attack_timer: Timer = $"AttackTimers/AttackTimer"
@onready var _cooldown_timer: Timer = $"AttackTimers/CooldownTimer"

@onready var _player: Node2D = get_tree().get_nodes_in_group("Player")[0]


func _ready() -> void:
	_current_state = "CHASE"


func _state_logic() -> void:
	pass


func _idle_logic() -> void:
	_debug_visual_enemy.color = _idle_color


func _chase_logic() -> void:
	_debug_visual_enemy.color = _chase_color
	if _get_player_direction() != _direction:
		_swap_direction()
	_chase()
	
	if _player_in_range:
		_current_state = "ATTACK"


func _attack_logic() -> void:
	_debug_visual_enemy.color = _attack_color
	if not _windup_timer.is_stopped() or\
		not _attack_timer.is_stopped() or\
		not _cooldown_timer.is_stopped(): return
		
	_stand()
	
	if not _player_in_range:
		_current_state = "CHASE"
		return

	_attack()


func _attack() -> void:
	_windup_timer.start()

	await _windup_timer.timeout
	_hit()
	_cooldown_timer.start()


func _hit() -> void:
	_attack_timer.start()
	_debug_visual_hurtbox.visible = true
	_hurtbox.monitoring = true

	await _attack_timer.timeout
	_debug_visual_hurtbox.visible = false
	_hurtbox.monitoring = false


func _get_player_direction() -> int:
	return int(sign(_player.global_position.x - global_position.x))


func _swap_direction() -> void:
	_direction = -_direction
	scale.x = -scale.x


func _chase() -> void:
	if (abs(_player.global_position.x - global_position.x) < 5):
		velocity.x = 0
		return

	velocity.x = _run_speed * _direction


func _stand() -> void:
	velocity.x = 0


func _on_hit(area: HittableComponent):
	area.hurt(_hit_damage)


func _on_player_in_range(_area):
	_player_in_range = true


func _on_player_out_of_range(_area):
	_player_in_range = false
