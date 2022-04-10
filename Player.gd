extends Area2D

var speed = 0

var velocity = 0

var food = 15

onready var rightDtctor = $right
onready var leftDtctor = $left
onready var forwrdDtctor = $forward

onready var leftPixel = $UI/left
onready var frontPixel = $UI/front
onready var rightPixel = $UI/right

onready var transparent = $UI/transparent

var left = false
var right = false
var forward = false

var smart = false

func _process(delta: float) -> void:
	var world = get_parent().get_parent()
	world.get_child(0).canWASD = false
	food -= delta
	speed = 0
	if food <= 0:
		world.get_child(0).canWASD = true
		queue_free()
	
	left = !leftDtctor.get_overlapping_areas().empty()
	right = !rightDtctor.get_overlapping_areas().empty()
	forward = !forwrdDtctor.get_overlapping_areas().empty()
	
	var alpha = 1.0
	if transparent.pressed:
		alpha = 0.5
	
	if left:
		leftPixel.color = Color(1.0, 1.0, 1.0, alpha)
	else:
		leftPixel.color = Color(0.0, 0.0, 0.0, alpha)
	if right:
		rightPixel.color = Color(1.0, 1.0, 1.0, alpha)
	else:
		rightPixel.color = Color(0.0, 0.0, 0.0, alpha)
	if forward:
		frontPixel.color = Color(1.0, 1.0, 1.0, alpha)
	else:
		frontPixel.color = Color(0.0, 0.0, 0.0, alpha)
	
	if Input.is_action_pressed("left"):
		do(-1, delta)
	if Input.is_action_pressed("right"):
		do(1, delta)
	if Input.is_action_pressed("up"):
		do(2, delta)
	if Input.is_action_pressed("down"):
		do(-2, delta)
	
	velocity = lerp(velocity, speed, 0.12)
	position += Vector2(cos(rotation), sin(rotation)) * velocity * delta
	
	if position.x > world.space:
		position.x -= world.space * 2
	if position.x < -world.space:
		position.x += world.space * 2
	
	if position.y > world.space:
		position.y -= world.space * 2
	if position.y < -world.space:
		position.y += world.space * 2
	
	


func do(id, delta):
	if id == 1:
		rotation_degrees += 180 * delta
	if id == -1:
		rotation_degrees -= 180 * delta
	if id == 2:
		speed = 60
	if id == -2:
		speed = -20
	


func _on_Player_area_entered(area: Area2D) -> void:
	food += 2
	area.queue_free()


func _on_Button_button_down() -> void:
	get_parent().get_parent().get_child(0).canWASD = true
	queue_free()
