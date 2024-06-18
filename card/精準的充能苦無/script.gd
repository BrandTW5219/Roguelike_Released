extends Node


func effect(player_ball, enemy_ball, battle_system) -> void:
	# 精準的充能苦無
	if enemy_ball:
		enemy_ball.health -= 3
