extends CanvasLayer

var value = 0.0

onready var progressBar = $Progress

onready var label = $Label

func _process(delta: float) -> void:
	progressBar.rect_size.x = value * 170
	label.text = str(int(round(value * 100))) + "%"
