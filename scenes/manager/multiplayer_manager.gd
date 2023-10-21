extends Control

@export var adress = "127.0.0.1"
@export var port = 27015

@export var host_btn: Button
@export var join_btn: Button
@export var start_game_btn: Button

@export var scene: PackedScene

func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	host_btn.connect("pressed", on_host_pressed)
	join_btn.connect("pressed", on_join_pressed)
	start_game_btn.connect("pressed", on_start_game_pressed)

@rpc("any_peer", "call_local")
func start_game():
	get_tree().root.add_child(scene.instantiate())
	self.hide()

func player_connected(id):
	print("Player Connected: " + str(id))

func player_disconnected(id):
	print("Player Disconnected: " + str(id))

func connected_to_server():
	print("Connected To Server!")

func connection_failed():
	print("Connection Failed")

func on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 6)
	if error != OK:
		print("Host Failed: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	print("Waitning For Players!")

func on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(adress, port)
	if error != OK:
		print("Join Failed: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func on_start_game_pressed():
	start_game.rpc()
