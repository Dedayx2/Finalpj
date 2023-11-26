extends Character
class_name Enemy

#varible called path varible will store an array of points to the player
var path: PoolVector2Array
onready var animation_player = $AnimationPlayer
#for player and the other for the Naviagation2D
onready var navigation: Navigation2D = get_tree().current_scene.get_node("Rooms")
# ประกาศตัวแปร player จาก Node Kinematicbody2D get tree current_scene คืนค่าชื่อของฉากปัจจุบัน
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
onready var path_timer: Timer = get_node("PathTimer")

func _ready() -> void:
	var __ = connect("tree_exited", get_parent(), "_on_enemy_killed")


# func ไล่ล่า
func chase() -> void:
	if path:
		var vector_to_next_point: Vector2 = path[0] - global_position
		# length of the previous variable
		var distance_to_next_point: float = vector_to_next_point.length() 
		# ถ้า distance to next น้อยกว่่า 1  remove first points ใน path
		if distance_to_next_point < 4:
			# เปลี่ยน remove(0) เพื่อความเร็วในการเคลื่อนที่ของ enemy
			path.remove(0)
			 #  เช็คว่าถ้าใน path ไม่มี point return
			if not path:
				return
		#Update movement move_dictection ของ character class
		move_direction = vector_to_next_point
		# if enemy is moveing to the right การกลับด้าน animation
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			# false เพื่อคืนค่าแนวเดิม
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true


# มาจาก Node  connect the timeout signal คืนค่าเป็น void

func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
		
	else:
		path_timer.stop()
		path = []
		move_direction = Vector2.ZERO
		
		
func _get_path_to_player() -> void:
	# warning-ignore:return_value_discarded
	path = navigation.get_simple_path(global_position, player.position)









		
