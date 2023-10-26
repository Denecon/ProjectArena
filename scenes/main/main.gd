extends Node3D

@export var player_scene: PackedScene

func _ready():
	var index = 0
	for i in ServerManager.connected_players:
		var current_player = player_scene.instantiate() as Player
		current_player.player_name.text = ServerManager.connected_players[i].name
		current_player.name = str(ServerManager.connected_players[i].id)
		current_player.team = ServerManager.connected_players[i].team
		$Players.add_child(current_player)
		current_player.player_class.load_class()
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				current_player.global_position = spawn.global_position
		index += 1
