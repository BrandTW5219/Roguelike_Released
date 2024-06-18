extends CanvasLayer


const CARD = preload("res://card/card.tscn")


enum EventType {
	HEAL,
	INCREASE_MAX_HEALTH,
	CHOOSE_CARD,
}


var _chosen_card = null
var _event_type := EventType.HEAL
var _player: Player = null
var _room = null


@onready var context_label: Label = %ContextLabel
@onready var choose_card: MarginContainer = %ChooseCard


func _ready() -> void:
	_event_type = EventType.values().pick_random()
	if _event_type == EventType.HEAL:
		context_label.text = "使玩家滿血回復。"
	elif _event_type == EventType.INCREASE_MAX_HEALTH:
		context_label.text = "使玩家最大生命提升50。"
	elif _event_type == EventType.CHOOSE_CARD:
		context_label.text = "選擇任一張卡片加入至牌庫中"
		choose_card.visible = true
		%Card1.focus_entered.connect(update_chosen_card)
		%Card2.focus_entered.connect(update_chosen_card)
		%Card3.focus_entered.connect(update_chosen_card)
		%Card1.get_node("Card").id = randi_range(0, CardManager.get_card_count() - 1)
		%Card2.get_node("Card").id = randi_range(0, CardManager.get_card_count() - 1)
		%Card3.get_node("Card").id = randi_range(0, CardManager.get_card_count() - 1)
		%Card1.call_deferred("grab_focus")


func update_chosen_card() -> void:
		if %Card1.has_focus():
			_chosen_card = %Card1.get_node("Card")
		elif %Card2.has_focus():
			_chosen_card = %Card2.get_node("Card")
		elif %Card3.has_focus():
			_chosen_card = %Card3.get_node("Card")


func _on_confirm_button_pressed() -> void:
	if _event_type == EventType.HEAL:
		_player.health = _player.max_health
	elif _event_type == EventType.INCREASE_MAX_HEALTH:
		_player.max_health += 50.0
	elif _event_type == EventType.CHOOSE_CARD:
		var card = CARD.instantiate()
		card.id = _chosen_card.id
		_player.cards.append(card)
	_room.open_portal()
	queue_free()
