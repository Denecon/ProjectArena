extends Node
class_name BaseClass

@export var ability_array : Array[PackedScene]

var loaded_ability_array: Array[PackedScene]

var basic_attack_range = 0

var basic_attack : PackedScene

func load_abilities(list: Array[int]):
	basic_attack_range = 10
	
	loaded_ability_array.append(ability_array[list[0]])
	loaded_ability_array.append(ability_array[list[1]])
	loaded_ability_array.append(ability_array[list[2]])
	loaded_ability_array.append(ability_array[list[3]])

