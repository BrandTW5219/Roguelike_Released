extends Node2D


const GAME = preload("res://scene/game.tscn")
const PAUSE_MENU = preload("res://scene/pause_menu.tscn")


var _audio_base_power := 1.0


func _ready() -> void:
	var game: Node2D = GAME.instantiate()
	game.name = "game"
	add_child(game)
	var pause_menu: CanvasLayer = PAUSE_MENU.instantiate()
	pause_menu.name = "pause_menu"
	pause_menu.audio_base_power_changed.connect(func(value):
		_audio_base_power = value
		get_node("game").set_audio_base_power(value)
	)
	add_child(pause_menu)
	get_tree().paused = true


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and not event.pressed:
			var _paused = get_tree().paused
			get_tree().paused = not _paused
			get_node("pause_menu").visible = not _paused
