extends BaseProjectileAbility

func _physics_process(delta):
	direction.y = 0
	velocity = direction * speed
	move_and_slide()
