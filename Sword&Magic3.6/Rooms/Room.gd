extends Node2D

class_name room

export(bool) var boss_room: bool = false
const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Charecter/Enemy/SpawnExplosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://Charecter/Enemy/FlyingEnemy/FlyingEnemy.tscn"),
	"GOBLIN": preload("res://Charecter/Enemy/Goblin/Goblin.tscn"),
	"SLIME": preload("res://Charecter/Enemy/Slime/Slime.tscn"),
	"SLIMEBOOM": preload("res://Charecter/Enemy/Slimebomb/Slimebomb.tscn"),
	"BLUE_SLIEM" :preload("res://Charecter/Enemy/blueslime/BlueSlime.tscn"),
	"SLIME_BOSS": preload("res://Charecter/Enemy/Boss/SlimeBoss.tscn"),
	"NexusVoid": preload("res://Charecter/Enemy/Sorc/Soc.tscn"),
	"FLYINGSP": preload("res://Charecter/Enemy/FlyingEnemySp/FlyingEnemySp.tscn"),
	"FLYINGRED": preload("res://Charecter/Enemy/FlyingEnemyred/FlyingEnemyred.tscn"),
	"GOBLINBOOM": preload("res://Charecter/Enemy/GoblinBoom/GoblinBoom.tscn"),
	"GOBLINSP" : preload("res://Charecter/Enemy/GoblinSp/GoblinSp.tscn"),
	"GOBLINKING" : preload("res://Charecter/Enemy/KingofGoblin/GoblinKing.tscn"),
	
	
}

var num_enemies: int
onready var tilemap: TileMap = get_node("TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	
	
func _on_enemy_killed() -> void:
	num_enemies -= 1 
	if num_enemies == 0:
		_open_doors()
	
func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()
		
		
func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 0)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position) + Vector2.DOWN, 2)
		
		
func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: KinematicBody2D 
		if boss_room:	
			enemy = ENEMY_SCENES.SLIME_BOSS.instance()
			enemy = ENEMY_SCENES.NexusVoid.instance()	
				
		else:
			var random_enemy = randi() % 5
			if random_enemy == 0:
				enemy = ENEMY_SCENES.FLYING_CREATURE.instance()
			elif random_enemy == 1:
				enemy = ENEMY_SCENES.SLIME.instance()
			elif random_enemy == 2:
				enemy = ENEMY_SCENES.SLIMEBOOM.instance()
			elif random_enemy == 3:
				enemy = ENEMY_SCENES.BLUE_SLIEM.instance()	
			elif random_enemy == 4:
				enemy = ENEMY_SCENES.FLYINGSP.instance()
			elif random_enemy == 5:
				enemy = ENEMY_SCENES.FLYINGSP.instance()
			elif random_enemy == 6:
				enemy = ENEMY_SCENES.GOBLINBOOM.instance()
			elif random_enemy == 7:
				enemy = ENEMY_SCENES.GOBLINSP.instance()					 
			else:
				enemy = ENEMY_SCENES.GOBLIN.instance()
				
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)
		
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)
		


func _on_PlayerDetector_body_entered(_body: KinematicBody2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else:
		_close_entrance()
		_open_doors()


