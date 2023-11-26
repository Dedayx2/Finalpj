extends Node2D

onready var area = $Area2D
onready var coin_sprite = $AnimatedSprite
onready var coin_shadow = $Shadow
onready var particle  = $Particles2D
onready var coin_sound = $AudioStreamPlayer2D
onready var animation_player = $AnimationPlayer


enum STATE {
	IDLE,
	FOLLOW,
	COLLECT
}
var target_pos
var speed: float = 400
var state : int = STATE.IDLE
var target : KinematicBody2D 


func _ready() -> void:
	animation_player.play("Wave")

func _physics_process(delta: float) -> void:
	pass
	if state == STATE.FOLLOW:
		var spd = speed * delta
		
		if position.distance_to(target_pos) < spd:
			position = target_pos
			collect()
		else:	
			position = position.move_toward(target_pos, spd)

func collect() ->void:
	state = STATE.COLLECT
	coin_sprite.set_visible(false)
	coin_shadow.set_visible(false)
	particle.set_emitting(true)
	coin_sound.play()
	
	Event.emit_signal("coin_collected")
	
	yield(coin_sound, "finished")
	queue_free()

func _on_Area2D_body_entered(body: CollisionObject2D) -> void:
	if body != null:
		if body.name == "Player":
			target_pos = body.global_position
			state = STATE.FOLLOW
		else:
			pass


func _on_Timer_timeout() -> void:
	coin_sprite.play("Coin")


func _on_AnimatedSprite_animation_finished():
	if coin_sprite.get_animation() == "Coin":
		coin_sprite.play("Idle")

