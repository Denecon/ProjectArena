extends Control

@export var lobby_scene: PackedScene

@export var host_btn: Button
@export var join_btn: Button
@export var ready_up_btn: Button

@export var server_ip: LineEdit
@export var server_port: LineEdit

@export var player_name: LineEdit
@export var player_class: OptionButton
@export var player_team: OptionButton

func _ready():
	if "--server" in OS.get_cmdline_args():
		
		var arguments = {}
		for argument in OS.get_cmdline_args():
			# Parse valid command-line arguments into a dictionary
			if argument.find("=") > -1:
				var key_value = argument.split("=")
				arguments[key_value[0].lstrip("--")] = key_value[1]
		
		print("Server connected on " + str(arguments["ip"]) + "and port " + str(arguments["port"]))
		
		ServerManager.adress = str(arguments["ip"])
		ServerManager.port = int(arguments["port"])
		
		
		ServerManager.host_game()
		
		print("Starting Server!")
		return
	
	host_btn.connect("pressed", on_host_pressed)
	join_btn.connect("pressed", on_join_pressed)
	ready_up_btn.connect("pressed", on_ready_up_pressed)

func on_host_pressed():
	ServerManager.host_game()
	ServerManager.send_player_information(player_name.text, player_class.get_selected_id(), player_team.selected, multiplayer.get_unique_id())
	
	get_tree().root.add_child(lobby_scene.instantiate())
	get_tree().get_first_node_in_group("JoinScreen").hide()

func on_join_pressed():
	ServerManager.player_name = player_name.text
	ServerManager.player_class = player_class.get_selected_id()
	ServerManager.player_team = player_team.selected
	ServerManager.adress = server_ip.text
	ServerManager.port = server_port.text.to_int()
	ServerManager.join_game()
	
	get_tree().root.add_child(lobby_scene.instantiate())
	get_tree().get_first_node_in_group("JoinScreen").hide()
	

func on_ready_up_pressed():
	ServerManager.ready_up.rpc()
