extends Sprite3D
class_name HealthBar

@export var viewport: SubViewport
@export var bar: TextureProgressBar

func _ready(): 
	texture = viewport.get_texture()
	update(100)

func update(value):
	bar.update_bar(value)
