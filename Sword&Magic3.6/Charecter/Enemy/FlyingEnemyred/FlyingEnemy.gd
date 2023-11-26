extends Enemy

onready var hitbox: Area2D = get_node("Hitbox")

func _ready():
	print(accerelation)
	print(max_speed)

func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
