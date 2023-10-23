extends Area3D
class_name HurtboxComponent

@export var health_component : HealthComponent
@export var player_owner: Player

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(other_area: Area3D):
	if not other_area is HitboxComponent:
		return
	
	if other_area.team == player_owner.team:
		return
	
	other_area.owner.queue_free()
	
	if health_component == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
