extends CanvasLayer


const BALL = preload("res://battle/balls/ball.tscn")


@onready var balls: Node2D = %Balls
@onready var start_button: Button = %StartButton
@onready var cards: Node2D = %Cards
@onready var ball_stop_checker: Timer = %BallStopChecker


var _enemy_power := 1.0
var _player: Player = null
var _player_cards: Array = []
var _player_start_health := 20.0
var _player_start_atk := 1.0
var _player_start_max_health := 20.0
var _room = null


func _ready() -> void:
	var player_ball = BALL.instantiate() as Ball
	player_ball.type = Ball.Type.PLAYER
	player_ball.position = Vector2(-400, 0)
	player_ball.name = "player_ball"
	player_ball.health = _player_start_health
	player_ball.max_health = _player_start_max_health
	player_ball.atk = _player_start_atk

	var enemy_ball = BALL.instantiate() as Ball
	enemy_ball.position = Vector2(400, 0)
	enemy_ball.max_health = 5 * _enemy_power
	enemy_ball.health = 5 * _enemy_power
	enemy_ball.atk = 1.0 * _enemy_power
	enemy_ball.name = "enemy_ball"

	balls.add_child(player_ball)
	balls.add_child(enemy_ball)


func check_gameover() -> void:
	var player_flag = false
	var enemy_flag = false
	for ball in balls.get_children():
		player_flag = player_flag or ball.type == Ball.Type.PLAYER
		enemy_flag = enemy_flag or ball.type == Ball.Type.ENEMY
	if not player_flag or not enemy_flag:
		if balls.get_node("player_ball"):
			_player.health = balls.get_node("player_ball").health
			_player.max_health = balls.get_node("player_ball").max_health
			_player.atk = balls.get_node("player_ball").atk
		else:
			_player.queue_free()
		_room.open_portal()
		queue_free()


func locate_cards() -> void:
	var all_cards: Array = cards.get_children()
	var index := 0
	var card_count := len(all_cards)
	var card_spacing: float = min(150.0, 900.0 / card_count)
	for card in all_cards:
		card.get_node("card_draggable_2D").origin_position = Vector2(
			800.0 - (card_count - 1) * card_spacing / 2.0 + index * card_spacing,
			787.5
		)
		index += 1


func draw_card() -> void:
	if not is_node_ready():
		await ready
	if len(_player_cards) != 0:
		var card = _player_cards.pop_front()
		var card_draggable_2d := CardDraggable2D.new()
		card_draggable_2d.name = "card_draggable_2D"
		card_draggable_2d.battle_system = self
		card_draggable_2d.player_ball = balls.get_node_or_null("player_ball")
		card_draggable_2d.enemy_ball = balls.get_node_or_null("enemy_ball")

		var collision_shape_2d := CollisionShape2D.new()
		var rectangle_shape_2d := RectangleShape2D.new()
		rectangle_shape_2d.size = Vector2(150, 225)
		collision_shape_2d.shape = rectangle_shape_2d
		card_draggable_2d.add_child(collision_shape_2d)
		card.add_child(card_draggable_2d)
		cards.add_child(card)


func _on_start_button_button_down() -> void:
	start_button.disabled = true
	ball_stop_checker.start()

	for ball in balls.get_children():
		ball.ball_run()


func _on_ball_stop_checker_timeout() -> void:
	for ball in balls.get_children():
		if ball.linear_velocity != Vector2.ZERO:
			return
	ball_stop_checker.stop()
	start_button.disabled = false

	check_gameover()

	draw_card()


func _on_cards_child_entered_tree(node: Node) -> void:
	call_deferred("locate_cards")


func _on_cards_child_exiting_tree(node: Node) -> void:
	call_deferred("locate_cards")
