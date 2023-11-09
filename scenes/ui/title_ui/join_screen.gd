extends Control
class_name JoinScreen

@export var lobby_scene: PackedScene


@export var server_ip: LineEdit
@export var server_port: LineEdit


@export var back_btn: Button
@export var join_btn: Button


func _ready():
	back_btn.connect("pressed", on_back_btn_pressed)
	join_btn.connect("pressed", on_join_btn_pressed)

func on_back_btn_pressed():
	get_tree().get_first_node_in_group("StartScreen").show()
	queue_free()

func on_join_btn_pressed():
	ServerManager.set_player_information()
	ServerManager.join_game(server_ip.text, server_port.text.to_int())
	
	get_tree().root.add_child(lobby_scene.instantiate())
	get_tree().get_first_node_in_group("JoinScreen").hide()
