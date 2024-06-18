class_name Player
extends CharacterBody2D


const CARD = preload("res://card/card.tscn")


@export var max_health := 20.0
@export var health := 20.0
@export var atk := 1.0
@export_group("Movement")
# 加速度
@export_range(1, 1000, 1, "or_greater") var acceleration := 1000
# 摩擦力(減速)
@export_range(1, 1000, 1, "or_greater") var friction := 800
# 最大速度
@export_range(0, 1000, 1, "or_greater") var max_speed := 400


var cards := []


@onready var image = $Image as Sprite2D
@onready var hit_box = $HitBox
@onready var running_audio_stream_player: AudioStreamPlayer = $RunningAudioStreamPlayer


func _ready():
	add_to_group("PLAYER")

	for i in range(3):
		var card = CARD.instantiate()
		card.id = randi_range(0, CardManager.get_card_count() - 1)
		cards.append(card)


func _physics_process(delta):
	# 移動方向
	var direction = get_direction()

	# 移動時速度依據加速度遞增
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(
				direction.normalized() * max_speed,
				acceleration * delta
		)
	# 否則以摩擦力遞減
	else:
		velocity = velocity.move_toward(
				Vector2.ZERO,
				friction * delta
		)

	# 移動
	move_and_slide()

	if velocity.x > 0:
		image.flip_h = false
	elif velocity.x < 0:
		image.flip_h = true


func get_direction() -> Vector2:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		if not running_audio_stream_player.playing:
			running_audio_stream_player.playing = true
	else:
		running_audio_stream_player.playing = false
	return direction


func set_audio_base_power(value: float) -> void:
	running_audio_stream_player.volume_db = value
