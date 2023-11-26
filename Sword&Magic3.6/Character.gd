extends KinematicBody2D
class_name Character
# ประกาศ ตัวแปร
const FRICTION: float  = 0.15
#เร่งความเร็ว , speed , Hp

export(int) var hp: int = 10 setget set_hp
export(int) var max_hp: int = 10
export(int) var Str: int = 1 #test str
export(int) var stamina: int = 10 #Test stamina
signal hp_changed(new_hp)

export(int) var accerelation:int = 20 setget speed
export(int) var max_speed:int = 50 
export(bool) var flying: bool = false



const INDICATOR_DAMAGE = preload("res://GameUi/DamageIndicator.tscn")
onready var state_machine: Node = get_node("FSM")
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")


var move_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

# func ทำงาน every frame
func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)



# func move เรียกใช้ ตอน move character
func move() -> void:
	#call normalized
	move_direction = move_direction.normalized()
	velocity += move_direction * accerelation
	# clamped ค่า ไม่น้อยกว่าขั้นต่ำและไม่เกินสูงสุด

func take_damage(dam: int, dir: Vector2, force: int) -> void:
	self.hp -= dam
	if name == "Player":
		SavedData.hp = hp
	spawn_dmgIndicator(dam)
	if hp > 0:
		state_machine.set_state(state_machine.states.hurt)
		velocity += dir * force
	else:
		if collision_layer == 4:
			pass
		state_machine.set_state(state_machine.states.dead)
		velocity += dir * force * 2
		
		
func _spawn_content() -> void:
	Event.emit_signal("spawn_coin", global_position)
		

# spawn effect test
func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position
		return effect

# spawn damage 
func spawn_dmgIndicator(damage: int):
	var indicator = spawn_effect(INDICATOR_DAMAGE)
	if indicator:
		indicator.label.text = str(damage)


func set_hp(new_hp: int) -> void:
	hp = int(clamp(new_hp , 0 , max_hp))
	emit_signal("hp_changed",hp)
	
func speed(new_speed: int) :
	accerelation = new_speed


	
	
