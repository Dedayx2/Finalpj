extends CanvasLayer
var max_hp: int 


const INVENTORY_ITEM_SCENE: PackedScene = preload("res://Charecter/Player/Inventory/InventoryItem.tscn")
onready var inventory: HBoxContainer = get_node("PanelContainer/Inventory")
onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var hp_bar: ProgressBar = get_node("HPbar")
onready var coin_label = $Coins
onready var floor_label = $Floor


func _on_Player_weapon_switched(prev_index: int, new_index: int) -> void:
	inventory.get_child(prev_index).deselect()
	inventory.get_child(new_index).select()



func _on_Player_weapon_picked_up(weapon_texture: Texture) -> void:
	var new_inventory_item: TextureRect = INVENTORY_ITEM_SCENE.instance()
	inventory.add_child(new_inventory_item)
	new_inventory_item.initialize(weapon_texture)


func _on_Player_weapon_droped(index: int) -> void:
	inventory.get_child(index).queue_free()
	
func _ready():
	max_hp = player.max_hp
	update_hp_bar(player.hp)
	# warning-ignore:return_value_discarded
	Event.connect("nb_coins_changed", self ,"_on_Event_coin_changed")
	

func update_hp_bar(new_hp: int) -> void:
	hp_bar.value = new_hp
	hp_bar.max_value = max_hp
	print(max_hp)


func _on_Player_hp_changed(new_hp) -> void:
	var new_playerhp: int = new_hp
	update_hp_bar(new_playerhp)
	print(max_hp)
	
func _on_Event_coin_changed(coins: int) -> void:
	coin_label.set_text(String(coins))
	
func _physics_process(_delta):
	floor_label.text = String(AllDamage.Floor)


