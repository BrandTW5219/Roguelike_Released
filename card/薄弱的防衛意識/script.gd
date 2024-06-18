extends Node


func effect(player_ball, enemy_ball, battle_system) -> void:
	# 薄弱的防衛意識
	if player_ball:
		player_ball.health += 2
