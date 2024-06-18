extends Control


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			call_deferred("grab_focus")
			grab_click_focus()


func _on_focus_entered() -> void:
	$Line2D.visible = true


func _on_focus_exited() -> void:
	$Line2D.visible = false
