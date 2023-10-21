extends CharacterBody3D

@export var movement_speed: float = 4.0
@export var navigation_agent: NavigationAgent3D
@export var player_mesh: MeshInstance3D
var movement_delta: float

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func _input(event):
	if Input.is_action_just_pressed("mouse_button_1"):
		screen_point_to_ray()

func _physics_process(delta):
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
	
	var mouse_position = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	ray_query.collide_with_areas = true
	
	var result = space_state.intersect_ray(ray_query)
	
	var target_position = result.position
	set_movement_target(target_position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
