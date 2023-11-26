extends Node2D

const dash_delay = 0.4
onready var duration_timer = $DuratuinTimer
onready var ghost_timer = $GhostTimer
onready var dash_timer = $Dashdelay
onready var animation = $AnimationPlayer
var ghost_scene = preload("res://Charecter/Player/Dash/DashGhost.tscn")
var can_dash = true
var animated_sprite1


func start_dash(animated_sprite,duration):
	animation.play("dash")
	self.animated_sprite1 = animated_sprite
	duration_timer.wait_time = duration
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()
	
func instance_ghost():
	var ghost: AnimatedSprite = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.animation = animated_sprite1.animation
	ghost.global_position = global_position
	ghost.frame = animated_sprite1.frame
	
func is_dashing():
	return !duration_timer.is_stopped()
	
func end_dash():
	ghost_timer.stop()
	can_dash = false
	dash_timer.start()



func _on_DuratuinTimer_timeout() -> void:
	end_dash()


func _on_GhostTimer_timeout():
	instance_ghost()


func _on_Dashdelay_timeout():
	can_dash = true
