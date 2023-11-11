extends Control
class_name HealthBarUI

@export var bar: TextureProgressBar
var _owner: Player

func _ready():
	if _owner.has_node("HealthComponent"):
		_owner.health_component.connect("health_changed", on_health_changed)
	on_health_changed(100)


func on_health_changed(value):
	bar.update_bar(value)
