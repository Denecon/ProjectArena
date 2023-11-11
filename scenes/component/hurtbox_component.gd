extends Area3D
class_name HurtboxComponent


@export var health_component : HealthComponent


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(hitbox_component: HitboxComponent):
	if not owner.has_node("HealthComponent"):
		return
	
	if has_node("HitParticles"):
		$HitParticles.emitting = true
	
	if hitbox_component.slow_time != 0:
		health_component.owner.slow_movement_speed(hitbox_component.slow_time, hitbox_component.slow_strenght)
	if hitbox_component.stun_time != 0:
		health_component.owner.stun(hitbox_component.stun_time)
	
	health_component.damage(hitbox_component.damage)

