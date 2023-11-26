extends Node2D



func _physics_process(delta):
	if AllDamage.savegame:
		get_tree().reload_current_scene()
