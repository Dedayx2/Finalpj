extends Camera2D

export var randomStrength: float = 0.5
export var shakeFade: float = 1.0

var Hurt_: bool = false
var rng = RandomNumberGenerator.new()

const D_Zone = 260

var shake_strength: float = 0.0

onready var Timerr = $Timer

func apply_shake():
	shake_strength = randomStrength

func _process(delta):
	if Hurt_:
		apply_shake()
		Timerr.start()
	if shake_strength > 0 :
		shake_strength = lerp(shake_strength,0,shakeFade * delta)
		
		offset = randomOffset()
	
	
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size	* 0.1
		if _target.length() < D_Zone:
			self.position = Vector2(0,0)
		else:
			self.position = _target.normalized() * (_target.length() - D_Zone) * 0.1





func _on_Timer_timeout():
	Hurt_ = false
	


