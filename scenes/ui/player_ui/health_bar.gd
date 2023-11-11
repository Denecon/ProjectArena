extends TextureProgressBar


func set_texture():
	texture_progress = load("res://assets/HealthBarEnemy.png")


func update_bar(amount):
	value = amount
