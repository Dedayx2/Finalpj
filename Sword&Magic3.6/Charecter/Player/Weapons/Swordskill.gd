extends EnemyHitbox


var ready = false
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var Delay: Timer = $Delay



func _ready():
	animation_player.play("swordskill2")
	ready = true

func _process(_delta):
	if ready:
		for body in get_overlapping_bodies():
			if body.name != 'Player':
				body.take_damage(damage_weapons, knockback_direction,0)
				ready = false
				Delay.start()

func _collide(body: KinematicBody2D) -> void:
	print('coll')
	if body != null:
		if body.name == 'Player':
			pass
		else:
			body.take_damage(damage_weapons, knockback_direction,0)
			


func _on_Delay_timeout():
	ready = true
