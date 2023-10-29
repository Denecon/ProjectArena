extends Area3D
class_name HitboxComponent

var damage = 0
var stun_time = 0
var slow_strenght = 0
var slow_time = 0

@onready var collision_shape : CollisionShape3D = $CollisionShape3D

func set_disabled(is_disabled: bool):
	collision_shape.set_deferred("disabled", is_disabled)
