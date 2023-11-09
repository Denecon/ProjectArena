extends CharacterBody3D
class_name Player

signal basic_attack(dict)

@export var canvas: CanvasLayer
@export var ui: PackedScene

@export var movement_speed: float = 4.0
@onready var base_movement_speed = movement_speed
@export var navigation_agent: NavigationAgent3D
@export var player_mesh: MeshInstance3D

@export var camera: Camera3D

@export var player_class : ClassManager
@export var multiplayer_synchromizer : MultiplayerSynchronizer
@export var health_component: HealthComponent

@export var player_name : Label3D
@export var player_hurtbox: Area3D
@export var player_collision: CollisionShape3D
@export var player_heathbar: Sprite3D

var team: int
var is_stuned: bool

var mouse_position: Vector3

func _ready() -> void:
	multiplayer_synchromizer.set_multiplayer_authority(str(name).to_int())
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	if not multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	var ui_inst = ui.instantiate()
	ui_inst.player_owner = self
	ui_inst.class_manager = player_class
	
	canvas.add_child(ui_inst)
	
	InputManager.connect("mouse_0", on_mouse_button_0_pressed)
	InputManager.connect("mouse_1", on_mouse_button_1_pressed)
	InputManager.connect("disconnect_input", on_disconnect_input)
	
	camera.current = true

func on_disconnect_input():
	InputManager.disconnect("mouse_0", on_mouse_button_0_pressed)
	InputManager.disconnect("mouse_1", on_mouse_button_1_pressed)

func on_mouse_button_0_pressed():
	print(screen_point_to_ray())

func on_mouse_button_1_pressed():
	var ray_result = screen_point_to_ray()
	if ray_result == {}:
		return
	if not str(ray_result.collider.name).is_valid_int():
		set_movement_target(mouse_position)
		return
	if team == ray_result.collider.team:
		set_movement_target(mouse_position)
		return
	if global_position.distance_to(ray_result.position) > player_class.loaded_player_class.basic_attack_range:
#		TODO: get to max range of attack range
		set_movement_target(ray_result.position)
		return
	basic_attack.emit(ray_result)

func _physics_process(delta):
	if not multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	mouse_position = screen_point_to_ray().position if screen_point_to_ray().has("position") else global_position
	
	if navigation_agent.is_navigation_finished():
		return
	
	move_player()

func screen_point_to_ray():
	var space_state = get_world_3d().direct_space_state
	
	var mouse = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse)
	var ray_end = ray_origin + camera.project_ray_normal(mouse) * 2000
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	ray_query.collide_with_areas = true
	
	return space_state.intersect_ray(ray_query)

func move_player():
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	player_mesh.look_at(next_path_position + Vector3(0,3,0))
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func slow_movement_speed(slow_time, slow_strenght):
	movement_speed *= slow_strenght
	get_tree().create_timer(slow_time).connect("timeout", on_mobility_impairment_timer_timeout)

func stun(stun_time):
	movement_speed = 0.01
	is_stuned = true
	get_tree().create_timer(stun_time).connect("timeout", on_mobility_impairment_timer_timeout)

func on_mobility_impairment_timer_timeout():
	if is_stuned:
		is_stuned = false
	health_component.current_shield = 0
	movement_speed = base_movement_speed

func buff(buff_duration, buff_movement_speed, buff_shield):
	if not is_stuned:
		movement_speed = base_movement_speed + buff_movement_speed 
	health_component.current_shield = buff_shield
	get_tree().create_timer(buff_duration).connect("timeout", on_mobility_impairment_timer_timeout)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

func set_spectator_mode():
	set_collision_layer_value(2, false)
	player_name.visible = false
	player_mesh.visible = false
	health_component.queue_free()
	player_heathbar.queue_free()
	player_class.queue_free()
	player_hurtbox.queue_free()
	player_collision.queue_free()
	camera.fov = 115
