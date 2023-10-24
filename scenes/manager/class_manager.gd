extends Node
class_name ClassManager

@export var player_owner: Player

@export var player_class: PackedScene
var loaded_player_class: BaseClass

func load_class():
	loaded_player_class = player_class.instantiate()
	loaded_player_class.load_abilities([0,0,0,0])
	
	if not player_owner.multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	player_owner.connect("basic_attack", on_basic_attack)
	
	InputManager.connect("abililty_1", on_ability_1_pressed)
	InputManager.connect("abililty_2", on_ability_2_pressed)
	InputManager.connect("abililty_3", on_ability_3_pressed)
	InputManager.connect("abililty_4", on_ability_4_pressed)

func on_basic_attack(dict):
	if player_owner.global_position.distance_to(dict.position) > loaded_player_class.basic_attack_range:
		return
	
	print("basic attack to " + str(dict.collider.name))

func on_ability_1_pressed():
	var position = player_owner.global_position + Vector3(0,3,0)
	var direction = (player_owner.mouse_positon - position).normalized()
	activate_ability_1.rpc(player_owner.team, position, direction)

func on_ability_2_pressed():
	var position = player_owner.global_position + Vector3(0,3,0)
	var direction = (player_owner.mouse_positon - position).normalized()
	activate_ability_2.rpc(player_owner.team, position, direction)

func on_ability_3_pressed():
	var position = player_owner.global_position + Vector3(0,3,0)
	var direction = (player_owner.mouse_positon - position).normalized()
	activate_ability_3.rpc(player_owner.team, position, direction)

func on_ability_4_pressed():
	var position = player_owner.global_position + Vector3(0,3,0)
	var direction = (player_owner.mouse_positon - position).normalized()
	activate_ability_4.rpc(player_owner.team, position, direction)

@rpc("any_peer", "call_local")
func activate_ability_1(team, position, direction):
	var ability = loaded_player_class.ability_1.instantiate() as Node3D
	get_tree().get_first_node_in_group("AbilityPool").add_child(ability)
	ability.hit_box.team = team
	ability.global_position = position
	ability.direction = direction

@rpc("any_peer", "call_local")
func activate_ability_2(team, position, direction):
	var ability = loaded_player_class.ability_2.instantiate() as Node3D
	get_tree().get_first_node_in_group("AbilityPool").add_child(ability)
	ability.hit_box.team = team
	ability.global_position = position
	ability.direction = direction

@rpc("any_peer", "call_local")
func activate_ability_3(team, position, direction):
	var ability = loaded_player_class.ability_3.instantiate() as Node3D
	get_tree().get_first_node_in_group("AbilityPool").add_child(ability)
	ability.hit_box.team = team
	ability.global_position = position
	ability.direction = direction

@rpc("any_peer", "call_local")
func activate_ability_4(team, position, direction):
	var ability = loaded_player_class.ability_4.instantiate() as Node3D
	get_tree().get_first_node_in_group("AbilityPool").add_child(ability)
	ability.hit_box.team = team
	ability.global_position = position
	ability.direction = direction
