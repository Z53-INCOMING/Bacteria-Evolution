extends Node2D

onready var path = $Path

var pos = Vector2.ZERO

onready var camera = $Camera2D

onready var segScene = preload("res://Segment.tscn")

var length = 10

func _ready() -> void:
	path.curve.clear_points()

func _process(delta: float) -> void:
	get_tree().paused = false
	var dir = get_global_mouse_position().angle_to_point(pos)
	pos += Vector2(cos(dir), sin(dir)) * 2.5
	path.curve.add_point(pos)
	if get_length() > length * 8:
		path.curve.remove_point(0)
	camera.current = true
	camera.global_position = pos


func _on_mouth_area_entered(area: Area2D) -> void:
	area.queue_free()
	grow()

func get_length():
	var prevPos = Vector2.ZERO
	var length = 0.0
	for point in path.curve.get_baked_points():
		if prevPos != Vector2.ZERO:
			length += prevPos.distance_to(point)
		prevPos = point
	return length

func grow():
	var seg = segScene.instance()
	path.add_child(seg)
	length += 1
	camera.zoom += Vector2(0.05, 0.05)
	camera.zoom.x = clamp(camera.zoom.x, 1.0, 10.0)
	camera.zoom.y = camera.zoom.x
