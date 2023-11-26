extends CanvasLayer

onready var SwordL = $Sword
onready var AxeL = $Axe
onready var BowL = $Bow
onready var button_axe = $AxeLV
onready var button_bow = $BowLV
onready var Alcoin = $ALCoin


func _ready():
	set_visible(false)
	Alcoin.hide()
func _input(event):
	
	if event.is_action_pressed('CheckL'):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused



func _on_Button_pressed():
	get_tree().paused = false
	set_visible(false)
	
func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible



func _on_Exit_pressed():
	get_tree().quit()

func _process(_delta):
	SwordL.set_text(String(AllDamage.SwordLevel))
	AxeL.set_text(String(AllDamage.AxeLevel))
	BowL.set_text(String(AllDamage.BowLevel))
	if AllDamage.AxeLevel < 0:
		button_axe.hide()
	if AllDamage.BowLevel < 0:
		button_bow.hide()
	


func _on_SwordLV_pressed():
	if AllDamage.Coin >= 30:
		AllDamage.SwordLevel += 1
	elif AllDamage.Coin < 30:
		pass

func _on_AxeLV_pressed():
	if AllDamage.Coin >= 30:
		AllDamage.AxeLevel += 1


func _on_BowLV_pressed():
	if AllDamage.Coin >= 30:
		AllDamage.BowLevel += 1


