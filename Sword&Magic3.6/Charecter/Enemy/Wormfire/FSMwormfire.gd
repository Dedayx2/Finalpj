extends FSM

func _init() -> void:
	_add_state("Idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")
	_add_state('attack')
	
	
func _ready() -> void:
	set_state(states.move)
	
func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.chase()
		parent.move()
		
func _get_transition() -> int:
	match state:
		states.Idle:
			if parent.distance_to_player >= parent.MAX_DISTANCE_TO_PLAYER or parent.distance_to_player <= parent.MIN_DISTANCE_TO_PLAYER:
				return states.move
		states.move:
			if parent.distance_to_player < parent.MAX_DISTANCE_TO_PLAYER and parent.distance_to_player > parent.MIN_DISTANCE_TO_PLAYER:
				return states.Idle
			elif parent.can_attack:
				return states.attack
		states.attack:
			if not parent.can_attack:
				return states.move
		states.hurt:
			if not animation_player.is_playing() :
				return states.move
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.Idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("walk")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
		states.attack:
			animation_player.play("attack")
