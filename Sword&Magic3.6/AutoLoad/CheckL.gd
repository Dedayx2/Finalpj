extends CanvasLayer

onready var SwordL = $VBoxContainer/Label

func _ready():
	set_visible(false)

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

func _process(_delta):
	SwordL.text = AllDamage.SwordLevel

