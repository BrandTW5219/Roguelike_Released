extends Node2D


@export var id := -1:
	set(value):
		id = CardManager.clamp_id(value)
		if not is_node_ready():
			await ready
		sprite_2d.texture = CardManager.get_texture(id)
		title_lable.text = CardManager.get_title(id)
		context_label.text = CardManager.get_context(id)
		effect_script.script = CardManager.get_card_script(id)


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var title_lable: Label = $TitleLable
@onready var context_label: Label = $ContextLabel
@onready var effect_script: Node = $EffectScript


func effect(player_ball, enemy_ball, battle_system) -> void:
	if effect_script.script:
		effect_script.effect(player_ball, enemy_ball, battle_system)
	queue_free()
