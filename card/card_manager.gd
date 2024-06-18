extends Node


var _contexts: Array[String] = []
var _image_textures: Array[CompressedTexture2D] = []
var _scripts: Array[Script] = []
var _titles: Array[String] = []


func _ready() -> void:
	var dir := DirAccess.open("res://card")
	for sub_dir_name in dir.get_directories():
		var sub_dir := DirAccess.open(dir.get_current_dir() + "/" + sub_dir_name)
		var context_file := FileAccess.open(sub_dir.get_current_dir() + "/context.txt", FileAccess.READ)
		var context := ""
		if FileAccess.get_open_error() == OK:
			context = context_file.get_as_text()
		_contexts.append(context)
		context_file.close()
		_image_textures.append(load(sub_dir.get_current_dir() + "/image.png"))
		_titles.append(sub_dir_name)
		_scripts.append(load(sub_dir.get_current_dir() + "/script.gd"))


func clamp_id(id: int) -> int:
	return clamp(id, -1, len(_titles) - 1)


func get_context(id: int) -> String:
	if id == -1:
		return ""
	return _contexts[id]


func get_card_count() -> int:
	return len(_titles)


func get_card_script(id: int) -> Script:
	if id == -1:
		return null
	return _scripts[id]


func get_texture(id: int) -> CompressedTexture2D:
	if id == -1:
		return null
	return _image_textures[id]


func get_title(id: int) -> String:
	if id == -1:
		return ""
	return _titles[id]
