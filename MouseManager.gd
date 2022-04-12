extends Node2D

func _process(delta: float) -> void:
	Input.warp_mouse_position(self.get_global_mouse_position() + (Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3)) * delta * 50))


