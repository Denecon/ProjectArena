extends Node
class_name ClassManager


@export var _owner: Player


var _class: PackedScene
var loaded_player_class: BaseClass


var ability_cooldowns = [0, 0, 0, 0]
var is_on_cooldown = [false, false, false, false]  
var mobility_cooldown = 0
var is_mobility_on_cooldown = false
var mobility_max_range = 0


signal ability_casted(ability, cooldown)
signal mobility_casted(cooldown)


func load_class():
	loaded_player_class = _class.instantiate()
	loaded_player_class.load_abilities(InformationManager._abilities)
	
	if not _owner.get_muliplayer_autority():
		return
	
	set_cooldowns()
	
	connect_input()


func set_cooldowns():
	for ability in ability_cooldowns.size():
		var ability_temp = loaded_player_class.loaded_ability_array[ability].instantiate() as Node3D
		ability_cooldowns[ability] = ability_temp.cooldown
		ability_temp.queue_free()
	
	var movement_temp = loaded_player_class.loaded_movement.instantiate() as Node3D
	mobility_cooldown = movement_temp.cooldown
	mobility_max_range = movement_temp.max_distance
	movement_temp.queue_free()


func connect_input():
	_owner.connect("basic_attack", on_basic_attack)
	
	InputManager.connect("abililty_pressed", on_abililty_pressed)
	InputManager.connect("movement_pressed", on_movement_pressed)
	InputManager.connect("disconnect_input", on_disconnect_input)


func on_disconnect_input():
	InputManager.disconnect("abililty_pressed", on_abililty_pressed)
	InputManager.disconnect("movement_pressed", on_movement_pressed)


func on_basic_attack(dict):
	return
	if _owner.global_position.distance_to(dict.position) > loaded_player_class.basic_attack_range:
		return
	
	print("basic attack to " + str(dict.collider.name))


func on_abililty_pressed(ability: int):
	if _owner.is_stuned or is_on_cooldown[ability]:
		return
	
	is_on_cooldown[ability] = true
	
	var position = _owner.global_position + Vector3(0,3,0)
	var direction = (get_mouse_position() - position).normalized()
	direction.y = 0
	
	var hit_layer = 4 if _owner.team == 1 else 3
	var impact_mask = 6 if _owner.team == 1 else 5
	
	activate_ability.rpc(ability, hit_layer, impact_mask, position, direction)
	
	get_tree().create_timer(ability_cooldowns[ability]).connect("timeout", func(): is_on_cooldown[ability] = false)
	ability_casted.emit(ability, ability_cooldowns[ability])


@rpc("any_peer", "call_local")
func activate_ability(ability_id, hit_layer, impact_mask, position, direction):
	var ability = loaded_player_class.loaded_ability_array[ability_id].instantiate() as Node3D
	
	if ability is BuffAbility:
		_owner.buff(ability.buff_duration, ability.buff_movement_speed, ability.buff_shield)
	else:
		ability.hit_box.set_collision_layer_value(hit_layer, true)
		ability.impact.set_collision_mask_value(impact_mask, true)
		_owner.add_child(ability)
		ability.global_position = position
		ability.direction = direction


func on_movement_pressed():
	if _owner.is_stuned or is_mobility_on_cooldown:
		return

	is_mobility_on_cooldown = true
	
	var position = get_mouse_position() - _owner.global_position
	if position.length() > mobility_max_range:
		var angle = _owner.global_position.angle_to(position)
		var x = mobility_max_range * cos(deg_to_rad(angle))
		var z = mobility_max_range * sin(deg_to_rad(angle))
		position = Vector3(x, position.y, z)
	
	_owner.global_position += position + Vector3(0,-1.5,0)
	_owner.set_movement_target(_owner.global_position)
	
	get_tree().create_timer(mobility_cooldown).connect("timeout", func(): is_mobility_on_cooldown = false)
	mobility_casted.emit(mobility_cooldown)


func get_mouse_position():
	var ray_result = InputManager.screen_point_to_ray()
	
	if ray_result == {}:
		return
	
	return ray_result.position if ray_result.has("position") else _owner.global_position
