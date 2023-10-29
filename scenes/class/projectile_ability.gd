extends Node3D
class_name ProjectileAbility

@export var projectile_life_time: Timer
@export var life_time: float = 0.3
@export_range(0, 1) var speed: float = 1

@export var damage : int = 10
@export var stun_time : int = 0
@export_range(0, 0.5) var slow_strenght: float = 0
@export_range(0, 5) var slow_time: float = 0

var direction: Vector3

@export var mesh: MeshInstance3D
@onready var hit_box = $HitboxComponent as HitboxComponent
@onready var impact = $ImpactComponent as Area3D

func _ready():
	set_as_top_level(true)
	
	projectile_life_time.connect("timeout", queue_free)
	projectile_life_time.start(life_time)
	
	impact.connect("body_entered", on_impact)
	
	hit_box.damage = damage
	hit_box.slow_strenght = slow_strenght
	hit_box.slow_time = slow_time
	hit_box.stun_time = stun_time

func _physics_process(delta):
	position += direction * speed

func on_impact(other_body):
	queue_free()
