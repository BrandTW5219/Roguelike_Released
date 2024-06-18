extends CharacterBody2D


signal hit_player


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		hit_player.emit()
		call_deferred("queue_free")
