extends Node3D

@export var player_scene: PackedScene
@export var classes: Array[PackedScene]

var team_1 = 0
var team_2 = 0

func _ready():
	spawn_players()

func spawn_players():
	for i in ServerManager.connected_players:
		var team = ServerManager.connected_players[i].team
		var current_player = player_scene.instantiate() as Player
		current_player.player_name.text = ServerManager.connected_players[i].name
		current_player.name = str(ServerManager.connected_players[i].id)
		$Players.add_child(current_player)
		if team == 0 or team == 3:
			current_player.set_spectator_mode()
			current_player.global_position = get_tree().get_first_node_in_group("SpawnSpectator").global_position
		else:
			current_player.health_component.connect("died", on_player_died)
			current_player.team = team
			var impact_layer = 5 if team == 1 else 6
			var hurt_mask = 3 if team == 1 else 4
			current_player.player_class.Class = classes[ServerManager.connected_players[i].class]
			current_player.set_collision_layer_value(impact_layer, true)
			current_player.player_hurtbox.set_collision_mask_value(hurt_mask, true)
			current_player.player_class.load_class()
		if team == 1:
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPointTeam1"):
				if spawn.name == str(team_1):
					current_player.global_position = spawn.global_position
			team_1 += 1
		if team == 2:
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPointTeam2"):
				if spawn.name == str(team_2):
					current_player.global_position = spawn.global_position
			team_2 += 1

func on_player_died(team: int):
	if team == 1:
		team_1 -= 1
	if team == 2:
		team_2 -= 1
	if team_1 == 0 or team_2 == 0:
		get_tree().create_timer(5).connect("timeout", on_timer_timeout)

func on_timer_timeout():
	InputManager.disconnect_player()
