extends Node3D

@export var player_scene: PackedScene

func _ready():
	var index = 0
	for i in GameManager.connected_players:
		var current_player = player_scene.instantiate()
		current_player.name = str(GameManager.connected_players[i].id)
		current_player.team = GameManager.connected_players[i].team
		$Players.add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				current_player.global_position = spawn.global_position
		index += 1
