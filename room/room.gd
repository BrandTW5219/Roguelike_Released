class_name Room
extends Node2D


signal should_create_battle_system(room)
signal should_create_event_system(room)
signal should_tp_player(send_pos)


enum RoomType {
	BATTLE,
	EVENT,
}


enum RoomEvent {
	HEAL,
	INCREASE_HEALTH,
	CHOOSE_CARD,
}


const BAT = preload("res://object/bat/bat.tscn")


@export var send_pos := Vector2.ZERO


func open_portal() -> void:
	$Portal.monitoring = true
	$Portal.visible = true


func set_send_vector(value: Vector2) -> void:
	send_pos = value


func _on_portal_body_entered(body: Node2D) -> void:
	if body is Player:
		should_tp_player.emit(send_pos)


func _on_room_type_setter_body_entered(body: Node2D) -> void:
	if body is Player:
		var room_type = randi_range(0, len(RoomType) - 1)
		if room_type == RoomType.BATTLE:
			var bat = BAT.instantiate()
			bat.position = Vector2(-300, 0)
			bat.hit_player.connect(func():
				should_create_battle_system.emit(self)
			)
			call_deferred("add_child", bat)
		elif room_type == RoomType.EVENT:
			should_create_event_system.emit(self)
		get_node("RoomTypeSetter").queue_free()
