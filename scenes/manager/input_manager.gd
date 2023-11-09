extends Node

signal mouse_0
signal mouse_1
signal abililty_pressed(int)
signal movement_pressed

signal disconnect_input

func _input(event):
	if Input.is_action_just_pressed("escape_button"):
		disconnect_player()
	
	if event.is_action_pressed("mouse_button_0"):
		emit_mouse_0()
	if event.is_action_pressed("mouse_button_1"):
		emit_mouse_1()
	if event.is_action_pressed("ability_button_1"):
		emit_abililty_pressed(0)
	if event.is_action_pressed("ability_button_2"):
		emit_abililty_pressed(1)
	if event.is_action_pressed("ability_button_3"):
		emit_abililty_pressed(2)
	if event.is_action_pressed("ability_button_4"):
		emit_abililty_pressed(3)
	if event.is_action_pressed("mobility_button"):
		emit_movement_pressed()

func screen_point_to_ray():
	var space_state = get_tree().get_first_node_in_group("Main").get_world_3d().direct_space_state
	
	var mouse = get_viewport().get_mouse_position()
	var ray_origin = get_viewport().get_camera_3d().project_ray_origin(mouse)
	var ray_end = ray_origin + get_viewport().get_camera_3d().project_ray_normal(mouse) * 2000
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	ray_query.collide_with_areas = true
	
	return space_state.intersect_ray(ray_query)

func emit_mouse_0():
	mouse_0.emit()

func emit_mouse_1():
	mouse_1.emit()

func emit_abililty_pressed(ability: int):
	abililty_pressed.emit(ability)

func emit_movement_pressed():
	movement_pressed.emit()

func disconnect_player():
	disconnect_input.emit()
	ServerManager.disconnect_local_player()
	ServerManager.disconnect_player.rpc(multiplayer.get_unique_id())
	get_tree().root.get_node("StartScreen").show()
	get_tree().root.remove_child(get_tree().root.get_node("Main"))
