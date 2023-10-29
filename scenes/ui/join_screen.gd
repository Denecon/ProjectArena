extends Control

@export var host_btn: Button
@export var join_btn: Button
@export var ready_up_btn: Button

@export var player_name: LineEdit
@export var player_class: OptionButton
@export var player_team: OptionButton

func _ready():
	if "--server" in OS.get_cmdline_args():
		ServerManager.host_game()
		print("Starting Server!")
		return
	
	host_btn.connect("pressed", on_host_pressed)
	join_btn.connect("pressed", on_join_pressed)
	ready_up_btn.connect("pressed", on_ready_up_pressed)

func on_host_pressed():
	ServerManager.host_game()
	ServerManager.send_player_information(player_name.text, player_class.get_selected_id(), player_team.selected, multiplayer.get_unique_id())

func on_join_pressed():
	ServerManager.player_name = player_name.text
	ServerManager.player_class = player_class.get_selected_id()
	ServerManager.player_team = player_team.selected
	ServerManager.join_game()

func on_ready_up_pressed():
	ServerManager.ready_up.rpc()
