extends Panel
class_name PlayerPanel


@export var player_name: Label
@export var player_class: Label


@export var ready_btn: Button


func _ready():
	ready_btn.connect("pressed", on_ready_btn_pressed)


func on_ready_btn_pressed():
	ServerManager.ready_up.rpc()
	ready_btn.disabled = true
