extends Area2D

var gestastionPeriod = 15.0

var bacteria = null

var energy = 10.0

var frame = 0

onready var visual = $visual

onready var hitbox = $hitbox

var toxic = false

onready var nano = preload("res://NanoEgg.tres")

onready var normal = preload("res://NormalEgg.tres")

onready var micro = preload("res://MicroEgg.tres")

onready var mega = preload("res://MegaEgg.tres")

var development = 0.0

func _ready() -> void:
	$Timer.start(gestastionPeriod)
	visual.frame = frame
	if toxic:
		visual.frame += 4
	match frame:
		0:
			hitbox.shape = mega
		1:
			hitbox.shape = normal
		2:
			hitbox.shape = micro
		3:
			hitbox.shape = nano

func _process(delta: float) -> void:
	development += delta

func _on_Timer_timeout() -> void:
	hatch()


func hatch():
	bacteria.global_position = global_position
	bacteria.food = development + 10.0
	get_parent().Bacteria.add_child(bacteria)
	queue_free()
