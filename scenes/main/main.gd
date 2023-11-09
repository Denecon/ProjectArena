extends Node3D

@export var player_scene: PackedScene
@export var classes: Array[PackedScene]

var team_1 = 0
var team_2 = 0

func _ready():
	spawn_players()

func spawn_players():
	for i in ServerManager.connected_players:
		var _player = player_scene.instantiate() as Player
		$Players.add_child(_player)
		
		var team = ServerManager.connected_players[i].team
		if team == 0 or team == 3:
			set_player_as_spectator(_player)
			return
		
		set_player(_player, team, i)
		if team == 1:
			join_team_1(_player)
		if team == 2:
			join_team_2(_player)


func set_player_as_spectator(_player):
	_player.set_spectator_mode()
	_player.global_position = get_tree().get_first_node_in_group("SpawnSpectator").global_position


func set_player(_player, team, index):
	_player.player_name.text = ServerManager.connected_players[index].name
	_player.name = str(ServerManager.connected_players[index].id)
	_player.team = team
	
	_player.health_component.connect("died", on_player_died)
	
	var impact_layer = 5 if team == 1 else 6
	var hurt_mask = 3 if team == 1 else 4
	_player.set_collision_layer_value(impact_layer, true)
	_player.player_hurtbox.set_collision_mask_value(hurt_mask, true)
	
	_player.player_class._class = classes[ServerManager.connected_players[index].class]
	_player.player_class.load_class()


func join_team_1(_player):
	for spawn in get_tree().get_nodes_in_group("PlayerSpawnPointTeam1"):
		if spawn.name == str(team_1):
			_player.global_position = spawn.global_position
	team_1 += 1


func join_team_2(_player):
	for spawn in get_tree().get_nodes_in_group("PlayerSpawnPointTeam2"):
		if spawn.name == str(team_2):
			_player.global_position = spawn.global_position
	team_2 += 1


func on_player_died(team: int):
	if team == 1:
		team_1 -= 1
	if team == 2:
		team_2 -= 1
	if team_1 == 0 or team_2 == 0:
		get_tree().create_timer(5).connect("timeout", on_disconnect_timer_timeout)

func on_disconnect_timer_timeout():
	InputManager.disconnect_player()
