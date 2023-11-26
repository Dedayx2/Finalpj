extends Enemy

const BULLET_SCREEN: PackedScene = preload("res://Charecter/Enemy/Goblin/Throwable.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 100
const MIN_DISTANCE_TO_PLAYER: int = 60

export(int) var projectile_speed: int = 250

var can_attack: bool = true
var distance_to_player: float

onready var attack_timer: Timer = get_node("AttackTimer")
onready var aim_raycast: RayCast2D = get_node("AimRaycast")

func _ready():
	max_hp += AllDamage.Floor
	hp += AllDamage.Floor


func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			aim_raycast.cast_to = player.position - global_position
			if can_attack and state_machine.state == state_machine.states.Idle and not aim_raycast.is_colliding():
				can_attack = false
				_throw_knife()
				attack_timer.start()
	else:
		path_timer.stop()
		path = []
		move_direction = Vector2.ZERO

func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	# warning-ignore:return_value_discarded
	path = navigation.get_simple_path(global_position, global_position + dir * 100)

func _throw_knife() -> void:
	var projectile: Area2D = BULLET_SCREEN.instance()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)

func _on_AttackTimer_timeout() -> void:
	can_attack = true
