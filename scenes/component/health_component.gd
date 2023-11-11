extends Node
class_name HealthComponent


signal died(value: int)
signal health_changed(value: int)


@export var max_health: float = 10

var current_health
var current_shield = 0


func _ready():
	current_health = max_health


func damage(value: float):
	if current_shield != 0:
		value -= current_shield
	current_health = max(current_health - value, 0)
	health_changed.emit(current_health)
	Callable(check_death).call_deferred()


func get_health_precent():
	if max_health <= 0:
		return
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit(owner.team)
		owner.set_spectator_mode()
