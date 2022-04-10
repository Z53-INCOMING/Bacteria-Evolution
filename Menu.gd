extends Node2D

onready var periodVisual = $periodVisual
onready var periodBar = $periodBar

onready var sharpnessVisual = $sharpnessVisual
onready var sharpnessBar = $sharpnessBar

onready var mapVisual = $mapVisual
onready var mapBar = $mapBar

func _ready() -> void:
	randomize()
	mapBar.value = round(rand_range(0.0, 3.0))
	periodBar.value = round(rand_range(0.0, 4.0))
	sharpnessBar.value = round(rand_range(-3.0, 3.0))

func _process(delta: float) -> void:
	mapVisual.frame = mapBar.value
	periodVisual.frame = periodBar.value
	sharpnessVisual.frame = sharpnessBar.value + 3

func _on_create_button_down() -> void:
	match float(mapBar.value):
		0.0:
			Globals.mapSize = 250
		1.0:
			Globals.mapSize = 750
		2.0:
			Globals.mapSize = 1500
		3.0:
			Globals.mapSize = 2500
	
	match float(periodBar.value):
		0.0:
			Globals.period = 700
		1.0:
			Globals.period = 400
		2.0:
			Globals.period = 250
		3.0:
			Globals.period = 160
		4.0:
			Globals.period = 90
	
	Globals.sharpness = 7 + (sharpnessBar.value * -2)
	
	SceneChanger.go_to_scene("res://World.tscn", self)
