extends BaseProjectileAbility

@export var set_speed: int

func _ready():
	speed = set_speed

func fire():
	direction.y = 0
	apply_impulse(direction * speed)
