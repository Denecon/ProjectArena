extends Control
class_name PlayerScreen


@export var player_name: LineEdit
@export var player_class: OptionButton
@export var player_team: OptionButton


@export var skill_1: OptionButton
@export var skill_2: OptionButton
@export var skill_3: OptionButton
@export var skill_4: OptionButton


@export var cancel_btn: Button
@export var save_btn: Button


func _ready():
	player_name.text = InformationManager._name
	player_class.selected = InformationManager._class
	player_team.selected = InformationManager._team
	
	skill_1.selected = InformationManager._abilities[0]
	skill_2.selected = InformationManager._abilities[1]
	skill_3.selected = InformationManager._abilities[2]
	skill_4.selected = InformationManager._abilities[3]
	
	cancel_btn.connect("pressed", on_cancel_btn_pressed)
	save_btn.connect("pressed", on_save_btn_pressed)


func on_cancel_btn_pressed():
	get_tree().get_first_node_in_group("StartScreen").show()
	queue_free()


func on_save_btn_pressed():
	InformationManager._name = player_name.text
	InformationManager._class = player_class.selected
	InformationManager._team = player_team.selected
	InformationManager._abilities = [skill_1.selected, skill_2.selected, skill_3.selected, skill_4.selected]
	
	InformationManager.save_player_information()
	
	get_tree().get_first_node_in_group("StartScreen").show()
	queue_free()
