extends Node2D

func _on_Timer_timeout() -> void:
	var space = get_parent().space
	
	$X/X2.rect_position *= Vector2(space, space)
	$X/X3.rect_position *= Vector2(space, space)
	$Y/Y2.rect_position *= Vector2(space, space)
	$Y/Y3.rect_position *= Vector2(space, space)
