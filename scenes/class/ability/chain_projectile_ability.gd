extends ProjectileAbility
class_name ChainProjectileAbility

@onready var particles := $Particles

var players_hit = []

func on_impact(other_body):
	if players_hit.has(other_body):
		return
	hit_box.set_disabled(false)
	get_tree().create_timer(0.1).connect("timeout", disable_hitbox)
	
	players_hit.append(other_body)
	
	speed = 0
	global_position = other_body.global_position
	particles.emitting = true
	mesh.visible = false
	projectile_life_time.start(0.6)
	
	if other_body == StaticBody3D:
		queue_free()

func disable_hitbox():
	hit_box.set_disabled(true)
