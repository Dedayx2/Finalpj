extends Area2D


var entered = false
func _on_Area2D_body_entered(_body: PhysicsBody2D):
	entered = true
	SavedData.hp = _body.hp

func _on_Area2D_body_exited(_body):
	entered = false
	
	
func _process(_delta):
	if entered == true: 
		if Input.is_action_just_pressed("ui_accept"):
			AllDamage.Floor += 1
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://World.tscn")
