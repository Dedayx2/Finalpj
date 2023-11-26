extends Area2D

var speed: int 


var direction: Vector2 = Vector2.ZERO
var is_dead := false

func launch(initial_position:Vector2, dir: Vector2 , speedd:int ) -> void:
	position = initial_position
	direction = dir
	speed = speedd


func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_Bullet_body_entered(_body):
	if _body != null:
		if _body.name != 'Player':
			speed = 0
			$AnimationPlayer.play("explosion")


func _on_Timer_timeout():
	_on_Bullet_body_entered(null)
