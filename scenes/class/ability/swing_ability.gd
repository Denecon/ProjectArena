extends Node3D
class_name SwingAbility


@export var cooldown: int = 10


@export var pivot: Marker3D
@export var projectile_life_time: Timer
@export var life_time: float = 0.3
@export var speed: float = 1


@export var damage : int = 10
@export var stun_time : int = 0
@export var slow_time: int = 0


var direction: Vector3


@export var mesh: MeshInstance3D
@onready var hit_box = $Pivot/HitboxComponent as HitboxComponent
@onready var impact = $Pivot/ImpactComponent as Area3D


var swinged = false
var fire = false


func _ready():
	projectile_life_time.connect("timeout", queue_free)
	projectile_life_time.start(life_time)
	
	
	
	hit_box.damage = damage
	hit_box.stun_time = stun_time


func _physics_process(delta):
	if not swinged:
		look_at(direction * 100)
		swinged = true


func end_swing():
	impact.connect("body_entered", on_impact)


func on_impact(other_body):
	queue_free()
