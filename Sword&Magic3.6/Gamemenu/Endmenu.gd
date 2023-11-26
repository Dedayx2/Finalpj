extends Control

onready var Timer = $Timer

var database = PostgreSQLClient.new()

var user = "postgres"
var password = "KRNSWL24UOItofBfbDdK"
var host = "containers-us-west-144.railway.app"
var port = 7306
var databaseConnection = "railway"



func _ready():
	#database.connect("connection_established",self, "selectFromDB")
	#database.connect("connecttion_error",self, "error")
	#database.connect("connecttion_closed",self, "closedConnection")
	
	
	database.connect_to_host("postgresql://%s:%s@%s:%d/%s" % [user,password,host,port,databaseConnection])
	pass 



func insertIntoDB(name,score,Floor):
	print("runing select query")
	
	var data = database.execute("""
	BEGIN;
	INSERT INTO scorededay (name,score,floor) values ('%s',%s,%s);
	commit;
	""" %[name,score,Floor])
	
func updateDB(name,score,Floor):
	print("runing select query")
	
	var data = database.execute("""
	BEGIN;
	update scorededay set score = %s , floor = %s where name = '%s';
	commit;
	""" %[Floor,score,name])

	
func selectFromDB():
	print("runing select query")
	
	var data = database.execute("""
	BEGIN;
	SELECT * FROM scorededay;
	commit;
	""")
	
	for d in data[1].data_row:
		print(d)

	
func _process(_delta):
	database.poll()
	pass

func closedConnection():
	print("database has closed!")
	
func _exit_tree():
	database.close()


func _on_Save_button_down():
	insertIntoDB($Name.text,AllDamage.Coin,AllDamage.Floor)
	pass
	
func _on_Update_button_down():
	updateDB($Name.text,AllDamage.Coin,AllDamage.Floor)
	pass # Replace with function body.



func _on_StartButton_pressed():
	get_tree().change_scene("res://World.tscn")
	AllDamage.reset_game()
	SavedData.weapons = []
	if AllDamage.savegame:
		Timer.start()
		
		
func _on_QuitButton_pressed():
	get_tree().change_scene("res://Gamemenu/MainMenu.tscn")


func _on_Timer_timeout():
	AllDamage.savegame = false





