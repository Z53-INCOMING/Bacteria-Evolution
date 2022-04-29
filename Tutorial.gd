extends Node2D

onready var camera = $Camera2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		camera.position.y += 180
	
