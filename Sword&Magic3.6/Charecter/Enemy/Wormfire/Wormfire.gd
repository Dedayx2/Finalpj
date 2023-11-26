extends Enemy

var rate : RandomNumberGenerator = RandomNumberGenerator.new()
const FIREBALL_SCENE: PackedScene = preload("res://Charecter/Enemy/Wormfire/Wormfireball.tscn")
const MAX_DISTANCE_TO_PLAYER: int = 100
var MIN_DISTANCE_TO_PLAYER: int = 0

export(int) var projectile_speed: int = 100

var can_attack: bool = true
var distance_to_player: float

onready var attack_timer: Timer = get_node("AttackTimer")

func _on_PathTimer_timeout() -> void:
	var per:int = rate.randi_range(1,2)
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER :
			print('เข้า')
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER :
			print('ออก')
			_get_path_to_move_away_from_player()
		elif can_attack:
				can_attack = false
				attack_timer.start()


	else:
		path_timer.stop()
		path = []
		move_direction = Vector2.ZERO
	
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	path = navigation.get_simple_path(global_position, global_position + dir * 100)


func _fire_ball() -> void:
	var projectile: Area2D = FIREBALL_SCENE.instance()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)

func _on_AttackTimer_timeout() -> void:
	can_attack = true


