extends Node2D

onready var camera = $Camera2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		camera.position.y += 180
	if Input.is_action_just_pressed("ui_down"):
		camera.position.y += 180
	if Input.is_action_just_pressed("ui_up"):
		camera.position.y -= 180
	if camera.position.y > (21 * 180):
		camera.position.y = 21 * 180


func _on_Button_button_down() -> void:
	get_tree().change_scene("res://Menu.tscn")
