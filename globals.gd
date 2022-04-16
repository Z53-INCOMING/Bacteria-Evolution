extends Node

var period = 160

var mapSize = 1500

var sharpness = 7

var mouseType = "Mouse"

var joy_mouse_pos = Vector2.ZERO

var markerColor = Color.red

#func get_true_mouse_pos():
#	match mouseType:
#		"Mouse":
#			return get_global_mouse_position()
#		"Joy":
#			return joy_mouse_pos
