extends SwingAbility

func _physics_process(delta):
	if not swinged:
		look_at(direction * 100)
		swinged = true
	if fire:
		position += direction * speed

func end_swing():
	set_as_top_level(true)
	fire = true
