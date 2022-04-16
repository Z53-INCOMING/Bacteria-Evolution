extends CanvasLayer

onready var scaleNumber = $scale
onready var gestationNumber = $gestation
onready var toxicCheck = $toxic
onready var oviparousCheck = $oviparous
onready var resistantCheck = $resistant
onready var nameEdit = $name

onready var eggLeftArrow = $left2
onready var eggRightArrow = $right2
onready var eggFrontArrow = $front2
onready var foodLeftArrow = $left
onready var foodRightArrow = $right
onready var foodFrontArrow = $front

var eggLeft = 0
var eggRight = 0
var eggFront = 0
var foodLeft = 0
var foodRight = 0
var foodFront = 0

onready var bacteriaScene = preload("res://Bacterium.tscn")

var firstPause = false

func syncArrow(arrow, value):
	arrow.frame = 0
	match value:
		0:
			arrow.frame = 1
		-1:
			arrow.rotation_degrees = -180
		1:
			arrow.rotation_degrees = 0
		2:
			arrow.rotation_degrees = -90
		-2:
			arrow.rotation_degrees = 90

func syncDirections():
	syncArrow(eggLeftArrow, eggLeft)
	syncArrow(eggRightArrow, eggRight)
	syncArrow(eggFrontArrow, eggFront)
	
	syncArrow(foodLeftArrow, foodLeft)
	syncArrow(foodRightArrow, foodRight)
	syncArrow(foodFrontArrow, foodFront)

func _ready() -> void:
	firstPause = get_tree().paused

func _process(delta: float) -> void:
	syncDirections()
	get_tree().paused = true

func _on_eggAvoid_button_down() -> void:
	eggLeft = 1
	eggRight = -1
	eggFront = -2

func _on_eggFollow_button_down() -> void:
	eggLeft = -1
	eggRight = 1
	eggFront = 2

func _on_foodAvoid_button_down() -> void:
	foodLeft = 1
	foodRight = -1
	foodFront = -2

func _on_foodFollow_button_down() -> void:
	foodLeft = -1
	foodRight = 1
	foodFront = 2


func _on_create_button_down() -> void:
	var bacterium = bacteriaScene.instance()
	bacterium.global_position = get_parent().global_position
	bacterium.mutate = false
	
	bacterium.scale = Vector2(scaleNumber.value, scaleNumber.value)
	bacterium.gestationPeriod = gestationNumber.value
	bacterium.toxic = toxicCheck.pressed
	bacterium.resistant = resistantCheck.pressed
	bacterium.oviparous = oviparousCheck.pressed
	if nameEdit.text != "Name":
		bacterium.name = nameEdit.text
		bacterium.changeName = false
	
	bacterium.onLeft = foodLeft
	bacterium.onRight = foodRight
	bacterium.onForward = foodFront
	
	bacterium.onEggLeft = foodLeft
	bacterium.onEggRight = eggRight
	bacterium.onEggForward = foodFront
	
	get_parent().get_parent().Bacteria.add_child(bacterium)
	get_tree().paused = firstPause
	queue_free()

func _on_foodNothing_button_down() -> void:
	foodLeft = 0
	foodRight = 0
	foodFront = 0

func _on_eggNothing_button_down() -> void:
	eggLeft = 0
	eggRight = 0
	eggFront = 0
