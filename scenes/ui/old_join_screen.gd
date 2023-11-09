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
	host_btn.connect("pressed", on_host_pressed)
	join_btn.connect("pressed", on_join_pressed)
	ready_up_btn.connect("pressed", on_ready_up_pressed)

func on_host_pressed():
	ServerManager.host_game(server_port.text.to_int())
	ServerManager.send_player_information(player_name.text, player_class.get_selected_id(), player_team.selected, multiplayer.get_unique_id())

func on_join_pressed():
	ServerManager.set_player_information()
	ServerManager.join_game(server_ip.text, server_port.text.to_int())

func on_ready_up_pressed():
	ServerManager.ready_up.rpc()
