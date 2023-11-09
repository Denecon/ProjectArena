extends ProjectileAbility
class_name AOEProjectileAbility


@onready var particles := $Particles


func on_impact(other_body):
	hit_box.set_disabled(false)
	get_tree().create_timer(0.1).connect("timeout", disable_hitbox)
	
	speed = 0
	particles.emitting = true
	mesh.visible = false
	projectile_life_time.start(0.6)
	
	if other_body == StaticBody3D:
		queue_free()


func disable_hitbox():
	hit_box.set_disabled(true)
