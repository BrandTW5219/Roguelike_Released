extends Node2D


const BATTLE_SYSTEM = preload("res://battle/battle_system.tscn")
const CARD = preload("res://card/card.tscn")
const EVENT_SYSTEM = preload("res://event/event_system.tscn")
const ROOM = preload("res://room/room.tscn")


# Each room is 1152 * 640
var room_index = 0
var room_spacing = 800
var portal_spacing = 64 * 9
var map_origin_x = 0
var map_origin_y = 0


@onready var player: Player = $Player
@onready var player_camera: Camera2D = $Player/Camera2D


func _ready():
	call_deferred("new_room")
	call_deferred("new_room")

	player.tree_exited.connect(func():
		if get_node("EndGameScreen"):
			get_node("EndGameScreen").set_score(room_index - 2)
			get_node("EndGameScreen").visible = true
	)


func create_battle_system(room) -> void:
	var battle_system = BATTLE_SYSTEM.instantiate()
	battle_system._enemy_power = (room_index - 1) * 0.3
	battle_system._player = player
	player.cards.shuffle()
	for card in player.cards:
		var _card = CARD.instantiate()
		_card.id = card.id
		battle_system._player_cards.append(_card)
	battle_system._player_start_atk = player.atk
	battle_system._player_start_health = player.health
	battle_system._player_start_max_health = player.max_health
	battle_system._room = room
	call_deferred("add_child", battle_system)


func create_event_system(room) -> void:
	var event_system = EVENT_SYSTEM.instantiate()
	event_system._player = player
	event_system._room = room
	call_deferred("add_child", event_system)


func getVector(ra) -> Vector2:
	var room_vec = Vector2(map_origin_x, map_origin_y + ra * room_spacing)
	return room_vec


func new_room() -> void:
	var room: Room = ROOM.instantiate()
	room.send_pos = getVector(room_index + 1)
	room.position = getVector(room_index)
	room.should_create_battle_system.connect(create_battle_system)
	room.should_create_event_system.connect(create_event_system)
	room.should_tp_player.connect(func(send_pos):
		player.position = send_pos
		new_room()
	)
	get_node("Rooms").call_deferred("add_child", room)
	room_index += 1
	$CanvasLayer/Label.text = str(room_index - 1)


func set_audio_base_power(value: float) -> void:
	player.set_audio_base_power(value)
