extends Node

@export var player_owner: Player

var ability_1 : PackedScene
var ability_2 : PackedScene
var ability_3 : PackedScene
var ability_4 : PackedScene

func _ready():
	ability_1 = load("res://scenes/class/mage/tier_one/fire_ball.tscn")

func _input(event):
	if not player_owner.multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	var position = player_owner.global_position + Vector3(0,3,0)
	var direction = (player_owner.mouse_positon - position).normalized()
	
	if Input.is_action_just_pressed("ability_button_1"):
		print(str(multiplayer.get_unique_id()) + " used ability 1")
		
		activate_ability_1.rpc(player_owner.team, position, direction)
#	if Input.is_action_just_pressed("ability_button_2"):
#		print(str(multiplayer.get_unique_id()) + " used ability 2")
#		activate_ability_2()
#	if Input.is_action_just_pressed("ability_button_3"):
#		print(str(multiplayer.get_unique_id()) + " used ability 3")
#		activate_ability_3()
#	if Input.is_action_just_pressed("ability_button_4"):
#		print(str(multiplayer.get_unique_id()) + " used ability 4")
#		activate_ability_4()

@rpc("any_peer", "call_local")
func activate_ability_1(team, position, direction):
	var ability = ability_1.instantiate() as Node3D
	get_tree().get_first_node_in_group("AbilityPool").add_child(ability)
	ability.hit_box.team = team
	ability.global_position = position
	ability.direction = direction

func activate_ability_2():
	pass

func activate_ability_3():
	pass

func activate_ability_4():
	pass
