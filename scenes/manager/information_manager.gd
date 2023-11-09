extends Node


var path = "user://"
var file_path = path + "player_information.tres"


var loaded_file


@export var reset: bool


@export var _name: String
@export var _class: int
@export var _team: int
@export var _abilities: Array[int]


func _ready():
	if reset:
		if ResourceLoader.exists(file_path):
			DirAccess.remove_absolute(file_path)
	
	if not ResourceLoader.exists(file_path):
		var new_file = PlayerInformation.new()
		new_file._name = _name
		new_file._class = _class
		new_file._team = _team
		new_file._abilities = _abilities
		ResourceSaver.save(new_file, file_path)
	
	if '.tres.remap' in file_path:
		file_path = file_path.trim_suffix('.remap')
	
	loaded_file = load(file_path) as PlayerInformation
	_name = loaded_file._name
	_class = loaded_file._class
	_team = loaded_file._team
	_abilities = loaded_file._abilities


func save_player_information():
	loaded_file._name = _name
	loaded_file._class = _class
	loaded_file._team = _team
	loaded_file._abilities = _abilities
	ResourceSaver.save(loaded_file, file_path)
