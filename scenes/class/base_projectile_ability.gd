extends CharacterBody3D
class_name BaseProjectileAbility

var direction: Vector3
var speed: int = 10
var team: int

@onready var hit_box = $HitboxComponent

func _ready():
	$ProjectileDuration.connect("timeout", on_projectile_duration_timeout)

func on_projectile_duration_timeout():
	queue_free()
