# 此物件會依據一定的物理法則碰撞彈跳
class_name Ball
extends RigidBody2D


enum Type{
	PLAYER,
	ENEMY,
}


@export var atk := 1
@export var max_health := 20.0
@export var health := 20.0:
	set(val):
		health = val
		if health_bar != null:
			health_bar.update(health, max_health)
		if health <= 0:
			die()
@export var type := Type.ENEMY


# 速度倍率
const SPEED_MULTIPLIER = 5
# 停下速度
const STOPPING_SPEED = 100
# 減速係數
const DECELERATION_FACTOR = 0.995


# 用於紀錄滑鼠是否在物件內
var is_mouse_entered = false
# 用於判斷滑鼠左鍵長按時是否在物件範圍內
var is_mouse_left_just_pressed = false
# 紀錄在物件範圍內左鍵長按時的滑鼠座標
var mouse_left_just_pressed_pos


@onready var health_bar = $HealthBar
@onready var ray_cast_2d = $RayCast2D
@onready var arrow = $RayCast2D/Arrow
@onready var image: Sprite2D = $Image
@onready var line_2d: Line2D = $Line2D


func _ready():
	# 若要使用 mouse_entered 與 mouse_exited
	# 必須將 input_pickable 設為 true
	input_pickable = true

	line_2d.width = 1
	for i in range(361):
		var angle = i * 2 * PI / 360
		const RADIUS = 100
		line_2d.add_point(RADIUS * Vector2(cos(angle), sin(angle)))

	if type == Type.PLAYER:
		image.texture = load("res://battle/balls/-1.png")
		image.hframes = 1
		image.vframes = 1
		image.scale = Vector2(0.5, 0.5)

	health_bar.update(health, max_health)


func _physics_process(delta):
	if type == Type.PLAYER:
		# 判斷是否在物件範圍內長按滑鼠左鍵
		# 並且物件沒有在移動
		# 如果是則紀錄滑鼠座標
		if is_mouse_entered and !is_mouse_left_just_pressed and Input.is_action_just_pressed("mouse_left") and linear_velocity.length() == 0:
			mouse_left_just_pressed_pos = get_global_mouse_position()
			is_mouse_left_just_pressed = true

		# 判斷是否一直長按
		# 如果是則更新箭頭
		if is_mouse_left_just_pressed:
			arrow.visible = true
			ray_cast_2d.target_position = mouse_left_just_pressed_pos - get_global_mouse_position()
			arrow.rotation = ray_cast_2d.target_position.angle() + PI / 2 - rotation
			arrow.scale.y = ray_cast_2d.target_position.length() / 260

		# 判斷滑鼠左鍵是否放開
		# 如果是則對物件施力
		if is_mouse_left_just_pressed and Input.is_action_just_released("mouse_left"):
			is_mouse_left_just_pressed = false
	elif type == Type.ENEMY:
		if linear_velocity == Vector2.ZERO and ray_cast_2d.target_position == Vector2.ZERO:
			arrow.visible = true
			ray_cast_2d.target_position = Vector2(
			randf_range(-400.0, 400.0),
			randf_range(-400.0, 400.0),
			)
			arrow.rotation = ray_cast_2d.target_position.angle() + PI / 2 - rotation
			arrow.scale.y = ray_cast_2d.target_position.length() / 260

	# 速度低於一定值時停下
	if linear_velocity.length() < STOPPING_SPEED:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0

	# 減速
	linear_velocity *= DECELERATION_FACTOR


func ball_collide(ball: Ball):
	if ball.type != type:
		health -= ball.atk


func die():
	queue_free()


func ball_run():
		linear_velocity = ray_cast_2d.target_position * SPEED_MULTIPLIER
		arrow.visible = false
		ray_cast_2d.target_position = Vector2.ZERO


func _on_body_entered(body: Node2D):
	if body.has_method("ball_collide"):
		ball_collide(body)


func _on_mouse_entered():
	is_mouse_entered = true


func _on_mouse_exited():
	is_mouse_entered = false
