extends Enemy

const THROWABLE_KNIFE_SCENE: PackedScene = preload("res://Charecter/Enemy/Goblin/Throwable.tscn")
onready var Shoot_timer = $Shoot_timer
onready var rotater = $Rotater


const rotate_speed = 100
const shooter_timer_wait_time = 0.3
const spawn_point_count = 4
const radius = 180

func _ready():
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * 1)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	Shoot_timer.wait_time = shooter_timer_wait_time
	Shoot_timer.start()
	
func _process(_delta: float) -> void:
	var new_rotation = rotater.rotation_degrees + rotate_speed * _delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	
func _on_Shoot_timer_timeout() -> void:
	var dirc = Vector2(rand_range(-5000, 5000), rand_range(-5000, 5000))
	for s in rotater.get_children():
		var THROWABLE_KNIFE = THROWABLE_KNIFE_SCENE.instance()
		get_tree().root.add_child(THROWABLE_KNIFE)
		THROWABLE_KNIFE.launch(global_position, (dirc).normalized() , 200)
