extends Node2D

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://Charecter/Enemy/FlyingEnemy/FlyingEnemy.tscn"),
	"GOBLIN": preload("res://Charecter/Enemy/Goblin/Goblin.tscn"),
	"SLIME": preload("res://Charecter/Enemy/Slime/Slime.tscn"),
	"SLIMEBOOM": preload("res://Charecter/Enemy/Slimebomb/Slimebomb.tscn"),
	"BLUE_SLIEM" :preload("res://Charecter/Enemy/blueslime/BlueSlime.tscn"),
	"SLIME_BOSS": preload("res://Charecter/Enemy/Boss/SlimeBoss.tscn"),

}
const MAGIC_SCENE: PackedScene = preload("res://Charecter/Enemy/Sorc/Magic.tscn")
onready var ENEMYSPAWN: Node2D = get_node('spawnEnemy')

func _ready():
	spawn()
	#var Magic = MAGIC_SCENE.instance()
	#get_parent().call_deferred('add_child', Magic)
	#Magic.global_position = body.position

func spawn() -> void:
	for Enemy_position in ENEMYSPAWN.get_children():
		var enemy: KinematicBody2D 
		enemy = ENEMY_SCENES.SLIME.instance()
		enemy.position = Enemy_position.position
		call_deferred("add_child", enemy)
