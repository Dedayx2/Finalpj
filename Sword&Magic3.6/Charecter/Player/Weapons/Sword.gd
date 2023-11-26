extends Node2D


export(bool) var on_floor: bool = false
export(int) var weapon_damage = 2
onready var player_detector: Area2D = get_node("PlayerDetector")
onready var tween: Tween = get_node("Tween")
onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("wave")
	if not on_floor:
		player_detector.set_collision_mask_bit(0, false)
		player_detector.set_collision_mask_bit(1, false)

func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	if body != null:
		# การเก็บอาวุธซ่ำ เพื่อเพิ่มเลเวลอาวุธ ----------------------------------*
		# ต้องไปเช็คอีกที ว่ามีอาวุธอยู่ในกระเป่าหรือป่าว ที่เหลือ *************************
		#check weapon ว่ามีไหม
		if name == 'Sword':
			if AllDamage.checkSword:
				AllDamage.SwordLevel += 1
				print(AllDamage.SwordLevel)
				queue_free()
		elif name == 'Axe':
			if AllDamage.checkAxe:
				AllDamage.AxeLevel += 1
				print(AllDamage.AxeLevel)
				queue_free()
			else:
				player_detector.set_collision_mask_bit(0, false)
				player_detector.set_collision_mask_bit(1, false)
				body.pick_up_weapon(self)
				position = Vector2.ZERO
				AllDamage.checkAxe = true
				AllDamage.AxeLevel += 1
		elif name == 'Bow':
			if AllDamage.checkBow:
				AllDamage.BowLevel += 1
				print(AllDamage.BowLevel)
				queue_free()
			else:
				player_detector.set_collision_mask_bit(0, false)
				player_detector.set_collision_mask_bit(1, false)
				body.pick_up_weapon(self)
				position = Vector2.ZERO
				AllDamage.checkBow = true
				AllDamage.BowLevel += 1
	else:
		var __ = tween.stop_all()
		assert(__)
		player_detector.set_collision_mask_bit(1, true)

func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	var __ = tween.interpolate_property(self, "position", initial_pos, final_pos, 0.8 , Tween.TRANS_QUART, Tween.EASE_OUT)
	assert(__)
	__ = tween.start()
	assert(__)
	player_detector.set_collision_mask_bit(0, true)


func _on_Tween_tween_completed(_object: Object, _key: NodePath):
	player_detector.set_collision_mask_bit(1, true)
	
func get_texture() -> Texture:
	return get_node("Sprite").texture
