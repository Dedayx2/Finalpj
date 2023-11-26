extends Enemy

const BULLET_SCREEN: PackedScene = preload("res://testbul/Bullet.tscn")
var rate : RandomNumberGenerator = RandomNumberGenerator.new()
onready var Shoot_timer = $Shoot_timer
onready var attack_timer = $attack_timer
onready var skillstop = $Skillstop
onready var at = $at
onready var rotater = $Rotater
onready var Ray = $RayCast2D
const MAX_DISTANCE_TO_PLAYER: int = 100
const MIN_DISTANCE_TO_PLAYER: int = 60
export(int) var projectile_speed: int = 250
var can_attack: bool = true
var distance_to_player: float
var can_skill: bool	 = true

const rotate_speed = 100
const shooter_timer_wait_time = 0.3
const spawn_point_count = 4
const radius = 180

enum {ST1,ST2,ST3}
var ST = ST1

func _ready():
	pass

func _on_PathTimer_timeout() -> void:
	var rat :int  = rate.randi_range(0,10)
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			Ray.cast_to = player.position - global_position
			if rat <= 5:
				ST = ST1
			elif rat >= 6:
				ST = ST2
			match ST:
				ST1:
					if can_attack and not Ray.is_colliding() and state_machine.state == state_machine.states.Idle:
						_throw_knife()
						can_attack = false
						attack_timer.start()
						print('ST1')
				ST2:
					if can_skill and state_machine.state == state_machine.states.Idle:
						Spawn_axe()
						can_skill = false
						at.start()
						Shoot_timer.one_shot = false
						skillstop.start()
	else:
		path_timer.stop()
		path = []
		move_direction = Vector2.ZERO
	
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	path = navigation.get_simple_path(global_position, global_position + dir * 100)

func _throw_knife() -> void:
	var projectile: Area2D = BULLET_SCREEN.instance()
	projectile.launch(global_position, (player.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)


func _process(_delta: float) -> void:
	var new_rotation = rotater.rotation_degrees + rotate_speed * _delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	
func _on_Shoot_timer_timeout() -> void:
	var dirc = Vector2(rand_range(-5000, 5000), rand_range(-5000, 5000))
	for s in rotater.get_children():
		var Bullet = BULLET_SCREEN.instance()
		get_tree().root.add_child(Bullet)
		Bullet.launch(global_position, (dirc).normalized() , 100)

func Spawn_axe() -> void:
	var step = 2 * PI / spawn_point_count
	
	for _i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * 1)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	Shoot_timer.wait_time = shooter_timer_wait_time
	Shoot_timer.start()
	

func _on_attack_timer_timeout():
	can_attack = true

func _on_at_timeout():
	can_skill = true
	
func _on_Skillstop_timeout():
	Shoot_timer.one_shot = true
