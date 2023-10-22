extends Node
class_name HealthComponent

signal died(value: int)
signal health_changed

@export var max_health: float = 10
var current_health


func _ready():
	current_health = max_health


func damage(value: float):
	current_health = max(current_health - value, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()


func get_health_precent():
	if max_health <= 0:
		return
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		if owner.name.contains("Player"):
			died.emit(owner.player_index)
		else:
			died.emit(owner.kill_value)
		owner.queue_free()
