extends EnemyHitbox


onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func _ready() -> void:
	animation_player.play("pierce")
	
func _collide(body: KinematicBody2D) -> void:
	if not body.flying:
		if body.collision_layer == 2:
			knockback_direction = (body.global_position - global_position).normalized()
			body.take_damagePlayer(damage_weapons, knockback_direction,knockback_force)
		else:
			knockback_direction = (body.global_position - global_position).normalized()
			body.take_damage(damage_weapons, knockback_direction,knockback_force)

