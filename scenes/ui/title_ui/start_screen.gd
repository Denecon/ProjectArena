extends Control


@export var host_screen: PackedScene
@export var join_screen: PackedScene
@export var player_screen: PackedScene


@export var host_btn: Button
@export var join_btn: Button
@export var player_btn: Button
@export var quit_btn: Button


func _ready():
	if "--server" in OS.get_cmdline_args():
		setup_server()
		return
	host_btn.connect("pressed", on_host_btn_pressed)
	join_btn.connect("pressed", on_join_btn_pressed)
	player_btn.connect("pressed", on_player_btn_pressed)
	quit_btn.connect("pressed", on_quit_btn_pressed)


func setup_server():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	
	print("Server connected on " + str(arguments["ip"]) + " and port " + str(arguments["port"]))
	#If needed Bind Ip
	ServerManager.host_game(int(arguments["port"]))
	
	print("Starting Server!")
	return


func on_host_btn_pressed():
	ServerManager.host_game(27015)
	ServerManager.set_host_information()
	get_tree().root.add_child(host_screen.instantiate())
	get_tree().get_first_node_in_group("StartScreen").hide()


func on_join_btn_pressed():
	get_tree().root.add_child(join_screen.instantiate())
	get_tree().get_first_node_in_group("StartScreen").hide()


func on_player_btn_pressed():
	get_tree().root.add_child(player_screen.instantiate())
	get_tree().get_first_node_in_group("StartScreen").hide()


func on_quit_btn_pressed():
	pass
