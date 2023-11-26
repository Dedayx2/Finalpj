extends Node


var Sword = true
var Axe = false
var Bow = false
#check weapon
var checkSword = true
var checkAxe = false
var checkBow = false
var savegame = false
# ฝาก
var Str: int
var Floor : int =  0 
var Coin : int  = 0 setget set_coins , get_coins
# Leval weapon
var SwordLevel = 0
var AxeLevel = -1
var BowLevel = -1

var Damge :int
func _ready() -> void:
	# warning-ignore:return_value_discarded
	Event.connect("coin_collected", self ,"_on_Event_coin_collected")

func set_coins(value: int) -> void:
	if value != Coin:
		Coin = value
		Event.emit_signal("nb_coins_changed", Coin)

func get_coins() -> int: 
	return Coin

func _on_Event_coin_collected() -> void:
	set_coins(Coin + 1)

func SwordDamage():
	if SwordLevel == 0:
		Damge = 2
	elif SwordLevel == 1:
		Damge = 2 + SwordLevel
	return Damge

func AxeDamage():
	if AxeLevel == 0:
		Damge = 3
	elif AxeLevel == 1:
		Damge = 3 + AxeLevel
	return Damge
	
func BowDamage():
	if BowLevel == 0:
		Damge = 1
	elif BowLevel == 1:
		Damge = 1 + BowLevel
	return Damge
	
func reset_game() :
	BowLevel = -1
	AxeLevel = -1
	SwordLevel = 0
	Floor = 0
	Coin = 0
	checkSword = true
	checkAxe = false
	checkBow = false
	savegame = false
	savegame = true

