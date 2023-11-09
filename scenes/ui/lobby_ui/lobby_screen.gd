extends Control


@export var player_panel: PackedScene


@export var team1: VBoxContainer
@export var team2: VBoxContainer


func _ready():
	ServerManager.connect("player_count_changed", on_player_count_changed)
	
	if InformationManager._team == 1:
		var panel = player_panel.instantiate() as PlayerPanel
		panel.player_name.text = InformationManager._name
		panel.player_class.text = str( InformationManager._class)
		team1.add_child(panel)
	else:
		var panel = player_panel.instantiate() as PlayerPanel
		panel.player_name.text = InformationManager._name
		panel.player_class.text = str( InformationManager._class)
		team2.add_child(panel)

func on_player_count_changed():
	print("player: " + str(multiplayer.get_unique_id()) + " joined lobby with lobby size:" + str(ServerManager.connected_players.size()))
	for player in ServerManager.connected_players:
		if ServerManager.connected_players[player].id != multiplayer.get_unique_id():
			print("player: " + str(multiplayer.get_unique_id()) + " adding other lobby")
			if ServerManager.connected_players[player].team == 1:
				join_team(team1, player)
			else:
				join_team(team2, player)
		else:
			print("player: " + str(multiplayer.get_unique_id()) + " adding self lobby")

func join_team(team, player):
	var panel = player_panel.instantiate() as PlayerPanel
	panel.player_name.text = ServerManager.connected_players[player].name
	panel.player_class.text = str(ServerManager.connected_players[player].class)
	panel.ready_btn.queue_free()
	team.add_child(panel)
