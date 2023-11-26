extends Area2D
class_name Hitbox

export(int) var damage_weapons: int = 2
var rate_cri : RandomNumberGenerator = RandomNumberGenerator.new()

var knockback_direction: Vector2 = Vector2.ZERO
export(int) var knockback_force: int = 100


onready var collision_shape: CollisionShape2D = get_child(0)

func _init() -> void:
	var __ = connect("body_entered", self, "_on_body_entered")
	
func _ready() -> void:
	assert(collision_shape != null)
	
func damaged():
	var damage = damage_weapons
	if AllDamage.Sword:
		damage = AllDamage.SwordDamage()
	elif AllDamage.Axe:
		damage = AllDamage.AxeDamage()
	elif AllDamage.Bow:
		damage = AllDamage.BowDamage()
	return damage
	
func critical():
	var damagereal = damaged()
	var cri_per:int = rate_cri.randi_range(0,10)
	var criticaldamage = damagereal*2
	if cri_per >= 8:
		return criticaldamage
	else:
		return damagereal
	
	
func _on_body_entered(body: KinematicBody2D) -> void:

	var _cri_per:int = rate_cri.randi_range(0,10)
	var damage = critical()
	if body.name == "SlimeBoss":
		body.take_damage(damage, knockback_direction,0)
	else:
		body.take_damage(damage, knockback_direction,knockback_force)
	




func _on_Hitbox_area_entered(_area: Area2D) -> void:
	if AllDamage.Axe == true:
		_area.queue_free()
