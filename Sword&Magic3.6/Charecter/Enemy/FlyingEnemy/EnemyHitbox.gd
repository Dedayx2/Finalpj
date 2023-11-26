extends Area2D
class_name EnemyHitbox

export(int) var damage_weapons: int = 1

var knockback_direction: Vector2 = Vector2.ZERO
export(int) var knockback_force: int = 500

var body_inside: bool  = false

onready var collision_shape: CollisionShape2D = get_child(0)
onready var timer: Timer = Timer.new()

func _init() -> void:
	var __ = connect("body_entered", self, "_on_body_entered")
	__ = connect('body_exited', self , '_on_body_exited')
	
func _ready() -> void:
	assert(collision_shape != null)
	timer.wait_time = 1
	add_child(timer)
	
func damaged():
	var damage = damage_weapons
	return damage
	
	
	
func _on_body_entered(body: KinematicBody2D) -> void:
	body_inside = true
	timer.start()
	while body_inside:
		_collide(body)
		yield(timer, 'timeout')
	
func _on_body_exited(_body: KinematicBody2D) -> void:
	body_inside = false
	timer.stop()
	
	
	
func _collide(body: KinematicBody2D) -> void:
	var damage = damaged()
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		body.take_damagePlayer(damage, knockback_direction,
	knockback_force)
	


