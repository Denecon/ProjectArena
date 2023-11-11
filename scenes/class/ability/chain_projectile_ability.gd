extends ProjectileAbility
class_name ChainProjectileAbility


@onready var particles := $Particles
@onready var detection_component : Area3D = $DetectionComponent


var players_in_range = []
var players_hit = []


func _ready():
	set_as_top_level(true)
	
	detection_component.set_collision_mask_value(5, impact.get_collision_mask_value(5))
	detection_component.set_collision_mask_value(6, impact.get_collision_mask_value(6))
	
	projectile_life_time.connect("timeout", queue_free)
	projectile_life_time.start(life_time)
	
	impact.connect("body_entered", on_impact)
	
	hit_box.damage = damage
	hit_box.slow_strenght = slow_strenght
	hit_box.slow_time = slow_time
	hit_box.stun_time = stun_time


func on_impact(other_body):
	if players_hit.has(other_body):
		return
	
	detection_component.set_deferred("disabled", false)
	players_in_range = detection_component.get_overlapping_bodies()
	get_tree().create_timer(0.1).connect("timeout", disable_detection)
	
	players_hit.append(other_body)
	
	speed = 0
	particles.emitting = true
	mesh.visible = true
	projectile_life_time.start(life_time)
	
	for player in players_hit.size():
		players_in_range.erase(players_hit[player])
	
	if players_in_range.size() > 0:
		get_tree().create_timer(0.3).connect("timeout", chain_attack)
	
	if other_body == StaticBody3D:
		queue_free()

func chain_attack():
	on_chain(players_in_range[0])

func on_chain(other_body):
	global_position = other_body.global_position
	global_position.y += 2
	
	players_hit.append(other_body)
	
	particles.emitting = true
	mesh.visible = true
	projectile_life_time.start(life_time)
	
	for player in players_hit.size():
		players_in_range.erase(players_hit[player])
	
	if players_in_range.size() > 0:
		get_tree().create_timer(0.3).connect("timeout", chain_attack)


func disable_detection():
	set_deferred("disabled", true)
