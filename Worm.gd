extends Node2D

onready var path = $Path

var pos = Vector2.ZERO

onready var camera = $Camera2D

func _ready() -> void:
	path.curve.clear_points()

func _process(delta: float) -> void:
	get_tree().paused = false
	camera.global_position = pos
	var dir = get_global_mouse_position().angle_to_point(pos)
	pos += Vector2(cos(dir), sin(dir)) * 2.5
	path.curve.add_point(pos)
	if get_length() > 80:
		path.curve.remove_point(0)


func _on_mouth_area_entered(area: Area2D) -> void:
	area.queue_free()

func get_length():
	var prevPos = Vector2.ZERO
	var length = 0.0
	for point in path.curve.get_baked_points():
		if prevPos != Vector2.ZERO:
			length += prevPos.distance_to(point)
		prevPos = point
	return length
