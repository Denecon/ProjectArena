extends ProjectileAbility

@export var pivot: Marker3D

@export var max_size: float
@export_range(0, 1) var scale_speed: float

var fired = false

func _physics_process(delta):
	if not fired:
		pivot.look_at(direction * 100)
		fired = true
	
	if mesh.scale.x < max_size:
		mesh.scale.x += scale_speed
		hit_box.scale.x += scale_speed
		impact.scale.x += scale_speed
	position += direction * speed

func on_impact(other_body):
	if other_body == StaticBody3D:
		queue_free()
