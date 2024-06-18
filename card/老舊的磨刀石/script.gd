extends Node


func effect(player_ball, enemy_ball, battle_system) -> void:
	# 老舊的磨刀石
	if player_ball:
		player_ball.atk += 1
