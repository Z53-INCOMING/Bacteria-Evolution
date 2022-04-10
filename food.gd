extends Area2D

var energy = 2.0

onready var timer = $Timer

func _ready() -> void:
	randomize()
	$visual.frame = round(rand_range(0, 6))
	timer.start(rand_range(10.0, 60.0))


func _on_Timer_timeout() -> void:
	queue_free()

