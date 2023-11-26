extends EnemyHitbox


var enemy_exited: bool = false
var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0

onready var animation_player = $AnimationPlayer


func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta

func spwanmagic(initial_position:Vector2,dir: Vector2) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir

	
	rotation += dir.angle() + PI/4
	


# warning-ignore:unused_argument
func _on_Throwable_body_exited(body: KinematicBody2D) -> void:
	if not enemy_exited:
		enemy_exited = true
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(2, true)
		set_collision_mask_bit(3, true)

func _collide(body: KinematicBody2D) -> void:
	if enemy_exited:
		if body != null:
			if body.name == 'Player':	
				body.take_damagePlayer(damaged(), knockback_direction, knockback_force)
			else:
				body.take_damage(damaged(),knockback_direction, knockback_force)
		queue_free()	
		
