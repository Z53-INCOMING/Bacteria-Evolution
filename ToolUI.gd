extends Label
tool

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		rect_position.y += 180
	if Input.is_action_just_pressed("ui_up"):
		rect_position.y -= 180
