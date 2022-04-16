extends Camera2D

onready var animator = $AnimationPlayer

onready var radiationBlaster = $RadiationBlaster

var mutateTimer = 0.05

func _process(delta: float) -> void:
	get_tree().paused = false
	radiationBlaster.global_position = get_global_mouse_position()
	radiationBlaster.rotation = get_local_mouse_position().angle()
	if get_local_mouse_position().length() > 80.0:
		var strength = (get_local_mouse_position().length() / 182.0)
		var direction = get_local_mouse_position().angle()
		position += Vector2(cos(direction), sin(direction)) * strength * delta * 300
	radiationBlaster.scale.y = sign(get_local_mouse_position().x)
	mutateTimer -= delta
	if mutateTimer < 0.0:
		mutateTimer = 0.0
	if Input.is_action_pressed("follow"):
		animator.play("blast")
		if mutateTimer == 0.0:
			mutateTimer = 0.05
			for life in radiationBlaster.get_overlapping_areas():
				life.tryMutation()
	else:
		animator.play("stop")
	var world = get_parent()
	if position.x > world.space:
		position.x -= world.space * 2
	if position.x < -world.space:
		position.x += world.space * 2
	
	if position.y > world.space:
		position.y -= world.space * 2
	if position.y < -world.space:
		position.y += world.space * 2

var quality = 100

var radius = 80.0

func _ready() -> void:
	var index = 0.0
	var poly = []
	
	for i in range(quality):
		poly.append(Vector2(cos(deg2rad(index)), sin(deg2rad(index))) * radius)
		index += 360.0 / quality
	
	$Polygon2D.polygon = poly
