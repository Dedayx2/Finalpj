extends Node2D

var coin_scene = preload("res://Coin.tscn")

func _ready() -> void:
	Event.connect("spawn_coin", self, "_on_Event_spawn_coin")

func _spawn_coin(pos: Vector2) -> void:
	var coin = coin_scene.instance()
	
	coin.set_position(pos)
	# warnings-disable
	owner.call_deferred("add_child", coin)
	
func _on_Event_spawn_coin(pos: Vector2) -> void:
	_spawn_coin(pos)
