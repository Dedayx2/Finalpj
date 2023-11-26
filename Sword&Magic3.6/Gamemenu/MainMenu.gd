extends Control

export var URL = "http://127.0.0.1:8000/"
onready var menu = $Menu
onready var options = $Setting
onready var videos = $Video
onready var audio = $Audio

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle()
		
func toggle():
	#ฟังชั่นสลับ
	visible = !visible
	get_tree().paused = visible
	
func _on_Start_pressed():
	toggle() 
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn") 
	
func show_and_hide(a,b):
	#ฟังชั่นการซ่อนการโชว์
	a.show()
	b.hide()


func _on_Setting_pressed():
	show_and_hide(options, menu)


func _on_Exit_pressed():
	get_tree().quit()


func _on_Video_pressed():
	show_and_hide(videos, options)


func _on_Audio_pressed():
	show_and_hide(audio, options)


func _on_BackSetting_pressed():
	# warning-ignore:return_value_discarded
	show_and_hide(menu,options)



func _on_FullScreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_Borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed


func _on_BackVideo_pressed():
	show_and_hide(options, videos)


func _on_Master_value_changed(value):
	volume(0, value)
	
func volume(bus_index , value):
	AudioServer.set_bus_volume_db(bus_index,value)	


func _on_Music_value_changed(value):
	volume(1, value)


func _on_SoundFX_value_changed(value):
	volume(2, value)


func _on_BackAudio_pressed():
	show_and_hide(options, audio)


func _on_Go_ToWeb_pressed():
	# warning-ignore:return_value_discarded
	OS.shell_open(URL)
	
