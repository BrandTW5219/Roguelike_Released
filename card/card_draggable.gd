class_name CardDraggable2D
extends Draggable2D

var player_ball = null
var enemy_ball = null
var battle_system = null


var origin_position := Vector2.ZERO:
	set(value):
		origin_position = value
		var parent = get_parent()
		if parent and parent is Node2D:
			if not parent.is_node_ready():
				await parent.ready
			parent.position = value


func _physics_process(delta: float) -> void:
	if not is_dragged:
		if get_parent().position.y < 675:
			get_parent().effect(player_ball, enemy_ball, battle_system)
		else:
			get_parent().position = origin_position
