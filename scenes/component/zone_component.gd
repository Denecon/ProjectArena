extends Area3D

@export var zone_timer: Timer
@export var zone_tick_timer: Timer

const TIME_PERIOD = 0.5

var shrink_zone := false
var time :float = 0

var players_not_in_zone = []


var zone_damage = 0

func _ready():
	zone_timer.connect("timeout", on_zone_time_timeout)
	zone_tick_timer.connect("timeout", on_zone_tick_timeout)
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)

func _process(delta):
	time += delta
	
	if not shrink_zone:
		return
	
	if time > TIME_PERIOD:
		scale -= Vector3(0.01, 0, 0.01)
		time = 0
	
	if snapped(scale.x,0.01) == 0.40:
		zone_damage = 15
		shrink_zone = false
		zone_timer.start(60)
	if snapped(scale.x,0.01) == 0.20:
		zone_damage = 30
		shrink_zone = false

func on_body_entered(other_body):
	print("enter")
	players_not_in_zone.erase(other_body)

func on_body_exited(other_body):
	print("exit")
	players_not_in_zone.append(other_body)

func on_zone_time_timeout():
	shrink_zone = true
	zone_timer.stop()

func on_zone_tick_timeout():
	for player in players_not_in_zone:
		if player.has_node("HealthComponent"):
			player.health_component.damage(zone_damage)
	zone_tick_timer.start(3)
