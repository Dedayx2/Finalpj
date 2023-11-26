extends Character




var speed = 500
const FRICTIO = 100
var animationPlayer = null
var mouse: Vector2
var current_weapon: Node2D
const dash_speed = 1000
const dash_duration = 0.4
var rotation_offset: int = 0
var rate : RandomNumberGenerator = RandomNumberGenerator.new()
var can_use_skill: bool = true

const ARROW_SCENE: PackedScene = preload("res://Charecter/Player/Weapons/Arrow.tscn")
const sle_SCENE: PackedScene = preload("res://Charecter/Player/Weapons/efs.tscn")



enum{UP,DOWN}

enum {
	SWORD,
	AXE,
	BOW,
}

var weaponstate = SWORD
enum {
	MOVE,
	ATTACK,
	SKILL,
	DEAD
}
var state = MOVE

signal weapon_switched(prev_index,new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_droped(index)

onready var Camera2d = $Camera2D
onready var AnimatedSprite3 = $AnimatedSprite3
onready var damage = get_node("Hitbox")
onready var weapons: Node2D = get_node("Weapons")
onready var dash = $Dash
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var body = $CollisionShape2D
onready var sword_hitbox: Area2D = get_node("Hitbox")
onready var animation_state = animation_tree.get("parameters/playback")
onready var cool_down_timer: Timer = get_node("Cooldown")

onready var audioStreamPlayer: = $Dash2
onready var audioHurt: = $Hurt
onready var audioDie: = $Die
onready var audioSlash: = $Slash
onready var audioPickupwepon = $pickupwepon
onready var audioSwicthwepon = $Switchwepon



func _ready():
	animation_tree.active = true
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
	_restore_previous_state()
	if can_use_skill:
		animation_player.play("effectcoll")


func _restore_previous_state() -> void:
	if AllDamage.Floor >= 1:
		self.hp = SavedData.hp
	for weapon in SavedData.weapons:
		weapon = weapon.duplicate()
		weapon.hide()
		weapon.position = Vector2.ZERO
		weapons.add_child(weapon)	
		emit_signal("weapon_picked_up", weapon.get_texture())
		emit_signal("weapon_switched", weapons.get_child_count() -2, weapons.get_child_count() -1)
		
	current_weapon = weapons.get_child(0)
	
	
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("cheat"):
		cool_down_timer.wait_time = 0.2
		print(hp)
	# STRDAMAGE
	AllDamage.Str = Str
	var _per:int = rate.randi_range(0,10)
	accerelation = dash_speed if dash.is_dashing() else speed
	if dash.is_dashing():
		body.disabled = true
	body.disabled = false
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	mouse = mouse_direction
	sword_hitbox.knockback_direction = mouse
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			match weaponstate:
				SWORD:
					if Input.is_action_just_pressed("ui_dash") && dash.can_dash && !dash.is_dashing():
						state = MOVE
						cancel_attack(delta)
					attack_sword(delta)
					
				AXE:
					if Input.is_action_just_pressed("ui_dash") && dash.can_dash && !dash.is_dashing():
						state = MOVE
						cancel_attack(delta)
					attack_axe(delta)
				BOW:
					if Input.is_action_just_pressed("ui_dash") && dash.can_dash && !dash.is_dashing():
						state = MOVE
						cancel_attack(delta)
					attack_bow(delta)
				
		SKILL:
			match weaponstate:
				SWORD:
					if AllDamage.Sword:
						ratesword(delta)
				AXE:
					if AllDamage.Axe:
						sword_skill(delta)
				BOW:
					if AllDamage.Bow:
						bow_skill(delta)
					
					
	if current_weapon.name == "Sword":
		AllDamage.Sword = true
		AllDamage.Axe = false
		AllDamage.Bow = false
		weaponstate = SWORD
	if current_weapon.name == "Axe":
		AllDamage.Sword = false
		AllDamage.Axe = true
		AllDamage.Bow = false
		weaponstate = AXE
	if current_weapon.name == "Bow":
		AllDamage.Sword = false
		AllDamage.Axe = false
		AllDamage.Bow = true
		weaponstate = BOW

func move_player(delta) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if Input.is_action_just_pressed("ui_dash") && dash.can_dash && !dash.is_dashing():
		dash.start_dash(animated_sprite,dash_duration)
		$Dash2.play()
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed , accerelation * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTIO * delta)
	velocity = move_and_slide(velocity)

func move_state(delta):
	move_player(delta)
	if Input.is_action_just_released("ui_swup"):
			_switch_weapon(UP)
	elif Input.is_action_just_released("ui_swdown"):
			_switch_weapon(DOWN)
	elif Input.is_action_just_pressed("ui_throw") and current_weapon.get_index() != 0:
		_drop_weapon()
	
	if Input.is_action_just_pressed("ui_attack"):
		attack()
		state = ATTACK
	if Input.is_action_just_pressed("ui_ability") and can_use_skill:
		attack()
		can_use_skill = false
		AnimatedSprite3.visible = false
		cool_down_timer.start()
		state = SKILL
	if Input.is_action_just_pressed("reset"):
		print(current_weapon.name)
		skill_tel()
	# fun Attack  
func sword_skill(_delta):
	animation_state.travel('Swordskill')
func attack_sword(_delta) :
	#move_player(delta)
	animation_state.travel("Swordattack")
func attack_axe(_delta) :
	velocity = Vector2.ZERO
	animation_state.travel("Axeattack")
	
func attack_bow(_delta) :
	animation_state.travel('Bow')
func bow_skill(_delta):
	animation_state.travel('Bowskill')
func ratesword(_delta):
	animation_state.travel('Swordrate')
	
func swordshoot(_offset: int) -> void:
	var sle: Area2D = sle_SCENE.instance()
	get_tree().current_scene.add_child(sle)
	sle.launch(global_position,mouse, 400)

func shoot(_offset: int) -> void:
	var arrow: Area2D = ARROW_SCENE.instance()	
	get_tree().current_scene.add_child(arrow)
	arrow.launch(global_position,mouse, 400)


func _switch_weapon(direction: int) -> void:
	var prev_index: int = current_weapon.get_index()
	var index: int = prev_index
	if direction == UP:
		index -= 1
		print("UP")
		if index < 0:
			index = weapons.get_child_count() -1
	else:
		index += 1
		print("DOWN")
		if index > weapons.get_child_count() - 1:
			index = 0
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	SavedData.equipped_weapon_index = index
	
	emit_signal("weapon_switched", prev_index, index)
	$Switchwepon.play()
	print("AXE",AllDamage.AxeLevel)
	print('SWORD',AllDamage.SwordLevel)
	print('BOW',AllDamage.BowLevel)
	print(current_weapon)

func pick_up_weapon(weapon: Node2D) -> void:
	SavedData.weapons.append(weapon.duplicate())
	var prev_index: int = SavedData.equipped_weapon_index
	var new_index: int = weapons.get_child_count()
	SavedData.equipped_weapon_index = new_index
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	current_weapon.hide()
	current_weapon = weapon
	current_weapon.hide()
	if new_index == prev_index:
		print(10)
	
	emit_signal("weapon_picked_up", weapon.get_texture())
	emit_signal("weapon_switched", prev_index, new_index)
	$pickupwepon.play()

func _drop_weapon() -> void:
	SavedData.weapons.remove(current_weapon.get_index() - 1)
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(UP)
	
	emit_signal("weapon_droped", weapon_to_drop.get_index())
	
	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	yield(weapon_to_drop.tween, "tree_entered")
	weapon_to_drop.show()
	
	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)


func attack_animation_finished():
	state = MOVE

func cancel_attack(_delta) -> void:
	if Input.is_action_just_pressed("ui_dash") && dash.can_dash && !dash.is_dashing():
		dash.start_dash(animated_sprite,dash_duration)


func take_damagePlayer(dam: int, dir: Vector2, force: int) -> void:
	self.hp -= dam
	if hp > 0:
		animation_player.play("hurt")
		velocity += dir * force *2
		Camera2d.Hurt_ = true
		$Hurt.play()
	else:
		animation_player.play("dead")
		velocity += dir * force * 2
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Gamemenu/Endmenu.tscn")
		
		





func skill_tel():
	var mouse_d: Vector2 = (get_global_mouse_position())
	position = mouse_d
	print(mouse_d)

func _on_Cooldown_timeout() -> void:
	can_use_skill = true
	AnimatedSprite3.visible = true
	animation_player.play("effectcoll")

func frameFreeze(timeScale , _duration):
	Engine.time_scale = timeScale
	#yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0

func testmoveattack(Mo: Vector2) -> void:
	self.position += Vector2(Mo) * 10
	
func attack() -> void:
	animation_tree.set("parameters/Swordattack/blend_position", mouse)
	animation_tree.set("parameters/Axeattack/blend_position", mouse)
	animation_tree.set("parameters/Swordskill/blend_position", mouse)
	animation_tree.set("parameters/Bow/blend_position", mouse)
	animation_tree.set("parameters/Swordrate/blend_position", mouse)
	animation_tree.set("parameters/Bowskill/blend_position",mouse)
	
