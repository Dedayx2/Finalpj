extends Node

onready var Player  = $Player
onready var worldSoubd = $WorldSound
func _init() -> void:
	randomize()


	var screen_size: Vector2 = OS.get_screen_size()
	var window_size: Vector2 = OS.get_window_size()
	
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)
	
func _ready():
	$WorldSound.play()
	pass # Replace with function body.'


