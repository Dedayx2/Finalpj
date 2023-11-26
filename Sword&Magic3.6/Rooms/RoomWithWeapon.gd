extends room


const WEAPONS: Array = [preload("res://Charecter/Player/Weapons/Axe.tscn"),
preload("res://Charecter/Player/Weapons/Bow.tscn"),preload("res://Charecter/Player/Weapons/Sword.tscn")]

onready var weapon_pos: Position2D = get_node("WeaponPos")


func _ready() -> void:
	var weapon: Node2D = WEAPONS[randi() % WEAPONS.size()].instance()
	weapon.position = weapon_pos.position
	weapon.on_floor = true
	add_child(weapon)
		


