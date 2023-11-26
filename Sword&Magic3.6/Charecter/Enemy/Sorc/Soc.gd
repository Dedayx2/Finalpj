extends Enemy

var rate : RandomNumberGenerator = RandomNumberGenerator.new()
const FIREBALL_SCENE: PackedScene = preload("res://Charecter/Enemy/Sorc/Fireball.tscn")
const MAGIC_SCENE: PackedScene = preload("res://Charecter/Enemy/Sorc/Magic.tscn")
const THROWABLE_KNIFE_SCENE: PackedScene = preload("res://Charecter/Enemy/Goblin/Throwable.tscn")
const SPAWN_SKILL: PackedScene = preload('res://testskill.tscn')
const MAX_DISTANCE_TO_PLAYER: int = 100
const MIN_DISTANCE_TO_PLAYER: int = 60

export(int) var projectile_speed: int = 300

var can_attack: bool = true
var distance_to_player: float
enum {ST1,ST2}
onready var attack_timer: Timer = get_node("AttackTimer")

func _ready():
	max_hp += AllDamage.Floor
	hp += AllDamage.Floor


func _on_PathTimer_timeout() -> void:
	var per:int = rate.randi_range(1,2)
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			if can_attack and state_machine.state == state_machine.states.Idle:
				can_attack = false
				if per == 1:
					_magic_attack()
				elif per == 2: 
					_fire_ball()
				if hp < 5:
					spawnskill()
				attack_timer.start()
	else:
		path_timer.stop()
		path = []
		move_direction = Vector2.ZERO
	
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	path = navigation.get_simple_path(global_position, global_position + dir * 100)

func _magic_attack() -> void:
	var magic: Area2D = MAGIC_SCENE.instance()
	magic.spwanmagic(player.position, (player.position - global_position).normalized())
	get_tree().current_scene.add_child(magic)
	
func _fire_ball() -> void:
	var projectile: Area2D = FIREBALL_SCENE.instance()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)

func _on_AttackTimer_timeout() -> void:
	can_attack = true

func spawnskill() -> void:
	var spawn_enemy = SPAWN_SKILL.instance()
	spawn_enemy.position = position
	get_parent().call_deferred('add_child', spawn_enemy)
