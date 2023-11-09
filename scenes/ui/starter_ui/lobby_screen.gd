extends Control

@export var player_panel: PackedScene

@export var team1: Node
@export var team2: Node

@rpc("any_peer", "call_local")
func on_connected_players_changed():
	print("player joined")
	for player in ServerManager.connected_players.size():
		if ServerManager.connected_players[player].team == 1:
			print("debug")
			var panel = player_panel.instantiate() as PlayerPanel
			panel.player_name.text = ServerManager.connected_players[player].name
			panel.player_class.text = ServerManager.connected_players[player].class
			team1.add_child(panel)
		else:
			var panel = player_panel.instantiate() as PlayerPanel
			panel.player_name.text = ServerManager.connected_players[player].name
			panel.player_class.text = ServerManager.connected_players[player].class
			team1.add_child(panel)
