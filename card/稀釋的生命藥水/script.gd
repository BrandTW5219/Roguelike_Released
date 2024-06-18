extends Node


func effect(player_ball, enemy_ball, battle_system) -> void:
	# 稀釋的生命藥水
	if player_ball:
		player_ball.health += 1
