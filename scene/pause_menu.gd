extends CanvasLayer


signal audio_base_power_changed(value: float)


@onready var main_v_box_container: VBoxContainer = %MainVBoxContainer
@onready var setting_v_box_container: VBoxContainer = %SettingVBoxContainer


var _will_change_action := ""
var _will_change_line_edit: LineEdit = null


func _ready() -> void:
	%SettingVBoxContainer/Audio/HScrollBar.value_changed.connect(func(value):
		audio_base_power_changed.emit(value)
	)
	main_v_box_container.visible = true
	setting_v_box_container.visible = false


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if _will_change_action != "":
			InputMap.action_get_events(_will_change_action)[0].keycode = event.keycode
			_will_change_line_edit.text = OS.get_keycode_string(event.keycode)
			_will_change_action = ""
			_will_change_line_edit = null


func _on_back_button_pressed() -> void:
	main_v_box_container.visible = true
	setting_v_box_container.visible = false


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_setting_button_pressed() -> void:
	main_v_box_container.visible = false
	setting_v_box_container.visible = true


func _on_exit_button_pressed():
	get_tree().quit()


func _on_visibility_changed() -> void:
	if visible:
		main_v_box_container.visible = true
		setting_v_box_container.visible = false


func _on_up_line_edit_focus_entered() -> void:
	_will_change_action = "up"
	_will_change_line_edit = %SettingVBoxContainer/InputKey/Up/LineEdit


func _on_left_line_edit_focus_entered() -> void:
	_will_change_action = "left"
	_will_change_line_edit = %SettingVBoxContainer/InputKey/Left/LineEdit


func _on_down_line_edit_focus_entered() -> void:
	_will_change_action = "down"
	_will_change_line_edit = %SettingVBoxContainer/InputKey/Down/LineEdit


func _on_right_line_edit_focus_entered() -> void:
	_will_change_action = "right"
	_will_change_line_edit = %SettingVBoxContainer/InputKey/Right/LineEdit
