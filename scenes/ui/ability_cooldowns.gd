extends Control
class_name AbilityCooldowns

const TIME_PERIOD = 1

var time = 0

var player_owner: Player
var class_manager: ClassManager

@export var ability_1: Label
@export var ability_2: Label
@export var ability_3: Label
@export var ability_4: Label
@export var mobility: Label

var ability_1_time: int
var ability_2_time: int
var ability_3_time: int
var ability_4_time: int
var mobility_time: int

func _ready():
	if not player_owner.multiplayer_synchromizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		return
	
	class_manager.connect("ability_casted", on_ability_casted)
	class_manager.connect("mobility_casted", on_mobility_casted)

func _process(delta):
	time += delta
	
	if time > TIME_PERIOD:
		ability_1_time = ability_1_time - 1 if ability_1_time - 1 > 0 else 0
		ability_1.text = str(ability_1_time)
		
		ability_2_time = ability_2_time - 1 if ability_2_time - 1 > 0 else 0
		ability_2.text = str(ability_2_time)
		
		ability_3_time = ability_3_time - 1 if ability_3_time - 1 > 0 else 0
		ability_3.text = str(ability_3_time)
		
		ability_4_time = ability_4_time - 1 if ability_4_time - 1 > 0 else 0
		ability_4.text = str(ability_4_time)
		
		mobility_time = mobility_time - 1 if mobility_time - 1 > 0 else 0
		mobility.text = str(mobility_time)
		
		time = 0

func on_ability_casted(ability, cooldown):
	if ability == 0:
		ability_1_time = cooldown
	if ability == 1:
		ability_2_time = cooldown
	if ability == 2:
		ability_3_time = cooldown
	if ability == 3:
		ability_4_time = cooldown

func on_mobility_casted(cooldown):
	mobility_time = cooldown
