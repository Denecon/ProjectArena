extends Node

signal mouse_0
signal mouse_1
signal abililty_1
signal abililty_2
signal abililty_3
signal abililty_4

func _input(event):
	if event.is_action_pressed("mouse_button_0"):
		emit_mouse_0()
	if event.is_action_pressed("mouse_button_1"):
		emit_mouse_1()
	if event.is_action_pressed("ability_button_1"):
		emit_abililty_1()
	if event.is_action_pressed("ability_button_2"):
		emit_abililty_2()
	if event.is_action_pressed("ability_button_3"):
		emit_abililty_3()
	if event.is_action_pressed("ability_button_4"):
		emit_abililty_4()

func emit_mouse_0():
	mouse_0.emit()

func emit_mouse_1():
	mouse_1.emit()

func emit_abililty_1():
	abililty_1.emit()

func emit_abililty_2():
	abililty_2.emit()

func emit_abililty_3():
	abililty_3.emit()

func emit_abililty_4():
	abililty_4.emit()
