extends TextureProgressBar

var green_gradient_texture_2d = preload("./green_gradient_texture_2d.tres") as GradientTexture2D
var yellow_gradient_texture_2d = preload("./yellow_gradient_texture_2d.tres") as GradientTexture2D
var red_gradient_texture_2d = preload("./red_gradient_texture_2d.tres") as GradientTexture2D

# Entity 發出 health_updated 訊號時呼叫
func update(health: int, max_health: int):
	value = health
	max_value = max_health

	# 血條根據比例變換顏色
	# 50%以上: 綠色
	# 20%以上: 黃色
	# 其他: 紅色
	var f = 1.0 * value / max_value
	texture_progress = (
			green_gradient_texture_2d if f > 0.5
			else yellow_gradient_texture_2d if f > 0.2
			else red_gradient_texture_2d
	)
