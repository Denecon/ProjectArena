extends CharacterBody3D
class_name Player

signal basic_attack(dict)

@export var movement_speed: float = 4.0
@export var navigation_agent: NavigationAgent3D
@export var player_mesh: MeshInstance3D

@export var camera: Camera3D

@export var player_class : ClassManager
@export var multiplayer_synchromizer : MultiplayerSynchronizer

@export var player_name : Label3D

var team: int

var movement_delta: float

var mouse_position: Vector3

func _ready() -> void:
	multiplayer_synchromizer.set_multiplayer_authority(str(name).to_int())
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	if not multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	InputManager.connect("mouse_0", on_mouse_button_0_pressed)
	InputManager.connect("mouse_1", on_mouse_button_1_pressed)
	
	camera.current = true

func on_mouse_button_0_pressed():
	print(screen_point_to_ray())

func on_mouse_button_1_pressed():
	var ray_result = screen_point_to_ray()
	if ray_result == {}:
		return
	if str(ray_result.collider.name).is_valid_int():
		if team == ray_result.collider.team:
			set_movement_target(mouse_position)
		else:
			if global_position.distance_to(ray_result.position) > player_class.loaded_player_class.basic_attack_range:
#				TODO: get to max range of attack range
				set_movement_target(ray_result.position)
			basic_attack.emit(ray_result)
	else:
		set_movement_target(mouse_position)

func _physics_process(delta):
	if not multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	mouse_position = screen_point_to_ray().position if screen_point_to_ray() != {} else global_position
	
	if navigation_agent.is_navigation_finished():
		return

	movement_delta = movement_speed * delta
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	player_mesh.look_at(next_path_position + Vector3(0,3,0))
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_delta
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func screen_point_to_ray():
	var space_state = get_world_3d().direct_space_state
	
	var mouse = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse)
	var ray_end = ray_origin + camera.project_ray_normal(mouse) * 2000
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	ray_query.collide_with_areas = true
	
	return space_state.intersect_ray(ray_query)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
