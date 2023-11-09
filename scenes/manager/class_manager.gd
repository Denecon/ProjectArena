extends Node
class_name ClassManager

@export var player_owner: Player

@export var Class: PackedScene
var loaded_player_class: BaseClass

var is_on_cooldown = [false, false, false, false]  
var is_mobility_on_cooldown = false

signal ability_casted(ability, cooldown)
signal mobility_casted(cooldown)

func load_class():
	loaded_player_class = Class.instantiate()
	loaded_player_class.load_abilities([0,1,2,3])
	
	if not player_owner.multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	player_owner.connect("basic_attack", on_basic_attack)
	
	InputManager.connect("abililty_pressed", on_abililty_pressed)
	InputManager.connect("movement_pressed", on_movement_pressed)
	InputManager.connect("disconnect_input", on_disconnect_input)

func on_disconnect_input():
	InputManager.disconnect("abililty_pressed", on_abililty_pressed)
	InputManager.disconnect("movement_pressed", on_movement_pressed)

func on_basic_attack(dict):
	return
	if player_owner.global_position.distance_to(dict.position) > loaded_player_class.basic_attack_range:
		return
	
	print("basic attack to " + str(dict.collider.name))

func on_abililty_pressed(ability: int):
	if player_owner.is_stuned:
		return
	if is_on_cooldown[ability]:
		return
	is_on_cooldown[ability] = true
	var ability_temp = loaded_player_class.loaded_ability_array[ability].instantiate() as Node3D
	get_tree().create_timer(ability_temp.cooldown).connect("timeout", func(): is_on_cooldown[ability] = false)
	ability_casted.emit(ability, ability_temp.cooldown)
	ability_temp.queue_free()
	var position = player_owner.global_position + Vector3(0,3,0)
	var direction = (player_owner.mouse_position - position).normalized()
	direction.y = 0
	var hit_layer = 4 if player_owner.team == 1 else 3
	var impact_mask = 6 if player_owner.team == 1 else 5
	activate_ability.rpc(ability, hit_layer, impact_mask, position, direction)

@rpc("any_peer", "call_local")
func activate_ability(ability_id, hit_layer, impact_mask, position, direction):
	var ability = loaded_player_class.loaded_ability_array[ability_id].instantiate() as Node3D
	if ability is BuffAbility:
		player_owner.buff(ability.buff_duration, ability.buff_movement_speed, ability.buff_shield)
	else:
		player_owner.add_child(ability)
		ability.global_position = position
		ability.direction = direction
		ability.hit_box.set_collision_layer_value(hit_layer, true)
		ability.impact.set_collision_mask_value(impact_mask, true)

func on_movement_pressed():
	if player_owner.is_stuned:
		return
	if is_mobility_on_cooldown:
		return
	is_mobility_on_cooldown = true
	var movement_temp = loaded_player_class.loaded_movement.instantiate() as Node3D
	get_tree().create_timer(movement_temp.cooldown).connect("timeout", func(): is_mobility_on_cooldown = false)
	mobility_casted.emit(movement_temp.cooldown)
	var position = player_owner.mouse_position - player_owner.global_position
	if position.length() > movement_temp.max_distance:
		var angle = player_owner.global_position.angle_to(position)
		position = Vector3(movement_temp.max_distance * cos(deg_to_rad(angle)), position.y, movement_temp.max_distance * sin(deg_to_rad(angle)))
	movement_temp.queue_free()
	player_owner.global_position += position + Vector3(0,-1.5,0)
	player_owner.set_movement_target(player_owner.global_position)
