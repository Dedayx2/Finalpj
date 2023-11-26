extends Enemy


func _ready():
	max_hp += AllDamage.Floor
	hp += AllDamage.Floor

func duplicate_slime() -> void:
	if scale > Vector2(1, 1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(rand_range(0,2 *PI))
		print(impulse_direction)
		_spawn_slime(impulse_direction)
		_spawn_slime(impulse_direction * -1)


func _spawn_slime(direction: Vector2) -> void:
	var slime: KinematicBody2D = load("res://Charecter/Enemy/Slimebomb/Slimebomb.tscn").instance()
	slime.position = position
	slime.scale = scale/2
	slime.hp = hp/2.0
	get_parent().add_child(slime)
	slime.velocity += direction * 150
