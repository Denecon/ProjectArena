extends Sprite3D
class_name IngameHealthBarUI


@export var viewport: SubViewport
@export var bar: TextureProgressBar


func _ready():
	if owner.has_node("HealthComponent"):
		owner.health_component.connect("health_changed", on_health_changed)
	texture = viewport.get_texture()
	on_health_changed(100)


func on_health_changed(value):
	bar.update_bar(value)

func set_health_bar_texture():
	bar.set_texture()
