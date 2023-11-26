extends EnemyHitbox


var swordeffect = load('res://Charecter/Player/Weapons/Swordskill.tscn')
var rate : RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_exited: bool = false
var enemy_soc: bool = false
var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0
onready var animation_player = $AnimationPlayer
var swordeffect_instance = swordeffect.instance()
func _ready():
	if animation_player == null:
		pass
	elif name == 'Magic':
		animation_player.play("Bomb")
		enemy_soc = true
	elif name == "Fireball":
		animation_player.play("Fireballboss")
	elif name == "Wormfireball":
		animation_player.play("Wormfireball")
	elif is_in_group('arrow'):
		if name == 'Arrow':
			animation_player.play("arrowww")
	elif is_in_group('Throwable'):
		animation_player.play("Throwable")
	


func launch(initial_position:Vector2,dir: Vector2, speed:int ) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	
	if name == 'Fireball' or 'Wormfireball':
		rotation += dir.angle() + PI/11
	else:
		rotation += dir.angle() + PI/4


func spwanmagic(initial_position:Vector2,dir: Vector2) -> void:
	position = initial_position
	direction = dir
	knockback_direction = dir
	enemy_soc = true

func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta




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
		if name == 'Wormfireball':
			if body != null:
				if body.name == 'Player':
					body.take_damagePlayer(damaged(), knockback_direction, knockback_force)
				else:
					body.take_damage(damaged(),knockback_direction, knockback_force)
			queue_free()
		else:
			if body != null:
				if body.name == 'Player':
					body.take_damagePlayer(damaged(), knockback_direction, knockback_force)
				else:
					if name == 'efs' or name == 'Arrow' or name == 'Swordskill2':
						body.take_damage(damaged(),knockback_direction, 0)
					else:
						body.take_damage(damaged(),knockback_direction, knockback_force)
			queue_free()
			if body != null:
				if name == 'efs':
					get_tree().current_scene.call_deferred('add_child', swordeffect_instance)
					swordeffect_instance.global_position = global_position
	elif enemy_soc:
		if body != null:
			if is_in_group('Magic'):
				if body.name == 'Player':
					body.take_damagePlayer(damaged(), knockback_direction, knockback_force)
				else:
					body.take_damage(damaged(),knockback_direction, knockback_force)
	
	
		

