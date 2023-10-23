extends CharacterBody3D

var direction: Vector3
var speed: int = 10
var team: int

@onready var hit_box = $HitboxComponent

func _ready():
	$Timer.connect("timeout", on_timer_timeout)

func _physics_process(delta):
	direction.y = 0
	velocity = direction * speed
	move_and_slide()

func on_timer_timeout():
	queue_free()
