extends Node


func effect(player_ball, enemy_ball, battle_system) -> void:
	# 窺視未來的代價
	if player_ball:
		player_ball.health -= 1
		if battle_system:
			battle_system.draw_card()
			battle_system.draw_card()
