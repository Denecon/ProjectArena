extends Node

@export var adress = "127.0.0.1"
@export var port = 27015

@export var scene: PackedScene

var connected_players = {}
var connected_ready = 0

var player_name: String
var player_class: int
var player_team: int

var active = false

func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func player_connected(id):
	print("Player Connected: " + str(id))

func player_disconnected(id):
	print("Player Disconnected: " + str(id))
	connected_players.erase(id)
	if "--server" in OS.get_cmdline_args():
		connected_ready -= 1
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		if player.name == str(id):
			player.queue_free()
	if connected_players.size() == 0:
		print("Reset Server")
		if get_tree().root.has_node("Main"):
			get_tree().root.remove_child(get_tree().root.get_node("Main"))
		print("Server Ready")

func connected_to_server():
	print("Connected To Server!")
	send_player_information.rpc_id(1, player_name, player_class, player_team, multiplayer.get_unique_id())

func connection_failed():
	print("Connection Failed")

func disconnect_local_player():
	connected_players = {}
	connected_ready = 0

@rpc("any_peer")
func disconnect_player(id):
	multiplayer.multiplayer_peer.disconnect_peer(id)

@rpc("any_peer", "call_local")
func start_game():
	get_tree().root.add_child(scene.instantiate())
	get_tree().get_first_node_in_group("JoinScreen").hide()

@rpc("any_peer", "call_local")
func ready_up():
	connected_ready += 1
	if connected_ready == connected_players.size():
		start_game()

@rpc("any_peer")
func send_player_information(_player_name: String, _player_class, _player_team: int, id):
	if not ServerManager.connected_players.has(id):
		connected_players[id] = {
			"name" : _player_name.substr(0, 16),
			"class": _player_class,
			"team": _player_team,
			"id" : id
		}
	
	if multiplayer.is_server():
		for i in ServerManager.connected_players:
			send_player_information.rpc(ServerManager.connected_players[i].name, ServerManager.connected_players[i].class, ServerManager.connected_players[i].team, i)


func host_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 6)
	if error != OK:
		print("Host Failed: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	print("Waitning For Players!")

func join_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(adress, port)
	if error != OK:
		print("Join Failed: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
