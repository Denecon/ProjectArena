extends Node

signal mouse_0
signal mouse_1
signal abililty_pressed(int)

signal disconnect_input

func _input(event):
	if Input.is_action_just_pressed("escape_button"):
		disconnect_player()
	
	if event.is_action_pressed("mouse_button_0"):
		emit_mouse_0()
	if event.is_action_pressed("mouse_button_1"):
		emit_mouse_1()
	if event.is_action_pressed("ability_button_1"):
		emit_abililty_pressed(0)
	if event.is_action_pressed("ability_button_2"):
		emit_abililty_pressed(1)
	if event.is_action_pressed("ability_button_3"):
		emit_abililty_pressed(2)
	if event.is_action_pressed("ability_button_4"):
		emit_abililty_pressed(3)

func emit_mouse_0():
	mouse_0.emit()

func emit_mouse_1():
	mouse_1.emit()

func emit_abililty_pressed(ability: int):
	abililty_pressed.emit(ability)

func disconnect_player():
	disconnect_input.emit()
	ServerManager.disconnect_local_player()
	ServerManager.disconnect_player.rpc(multiplayer.get_unique_id())
	get_tree().root.get_node("JoinScreen").show()
	get_tree().root.remove_child(get_tree().root.get_node("Main"))
