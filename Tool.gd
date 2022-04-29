extends Sprite
tool

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		position.y += 180
	if Input.is_action_just_pressed("ui_up"):
		position.y -= 180
