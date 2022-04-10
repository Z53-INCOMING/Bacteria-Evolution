extends Node2D

onready var base = $Base
onready var turret = $Turret
onready var nozzle = $Turret/Position2D

onready var ray = $Turret/RayCast2D
onready var aim = $Turret/Line2D

onready var missileScene = preload("res://Missile.tscn")

var frame = 0

func _process(delta: float) -> void:
	if ray.is_colliding():
		aim.default_color = Color(0.101961, 1, 0, 0.466667)
	else:
		aim.default_color = Color(1, 0, 0, 0.466667)
	get_tree().paused = false
	if Input.is_action_pressed("left"):
		base.rotation = lerp_angle(base.rotation, deg2rad(-90), 0.5)
		frame += delta * 10
		position += Vector2(-100, 0) * delta
	if Input.is_action_pressed("right"):
		base.rotation = lerp_angle(base.rotation, deg2rad(90), 0.5)
		frame += delta * 10
		position += Vector2(100, 0) * delta
	if Input.is_action_pressed("up"):
		base.rotation = lerp_angle(base.rotation, 0, 0.5)
		frame += delta * 10
		position += Vector2(0, -100) * delta
	if Input.is_action_pressed("down"):
		base.rotation = lerp_angle(base.rotation, deg2rad(180), 0.5)
		frame += delta * 10
		position += Vector2(0, 100) * delta
	if frame > 2.0:
		frame = 0.0
	base.frame = int(round(frame))
	turret.rotation = get_global_mouse_position().angle_to_point(turret.global_position)
	if Input.is_action_just_pressed("follow"):
		var missile = missileScene.instance()
		missile.global_transform = nozzle.global_transform
		missile.velocity = Vector2(cos(missile.rotation), sin(missile.rotation)) * 100
		if ray.is_colliding():
			missile.target = ray.get_collider()
		get_parent().add_child(missile)
	var world = get_parent()
	if position.x > world.space:
		position.x -= world.space * 2
	if position.x < -world.space:
		position.x += world.space * 2
	
	if position.y > world.space:
		position.y -= world.space * 2
	if position.y < -world.space:
		position.y += world.space * 2
