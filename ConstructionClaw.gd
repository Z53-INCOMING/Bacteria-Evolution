extends Node2D

onready var base = $treads

onready var bicep = $treads/base/bicepArm
onready var foreArm = $treads/base/bicepArm/foreArm
onready var claw = $treads/base/bicepArm/foreArm/claw
onready var clawVisual = $treads/base/bicepArm/foreArm/claw/visual

var frame = 0.0

var inClaw = null

var defPoly = [Vector2(-4.5, 0), Vector2(4.5, 0), Vector2(4.5, -18), Vector2(-4.5, -18)]

func _process(delta: float) -> void:
	$Camera2D.current = true
	$Camera2D.zoom = Vector2(1.0, 1.0)
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
	if Input.is_action_pressed("left"):
		base.rotation = lerp_angle(base.rotation, deg2rad(-90), 0.5)
		frame += delta * 10
		position += Vector2(-50, 0) * delta
	if Input.is_action_pressed("right"):
		base.rotation = lerp_angle(base.rotation, deg2rad(90), 0.5)
		frame += delta * 10
		position += Vector2(50, 0) * delta
	if Input.is_action_pressed("up"):
		base.rotation = lerp_angle(base.rotation, 0, 0.5)
		frame += delta * 10
		position += Vector2(0, -50) * delta
	if Input.is_action_pressed("down"):
		base.rotation = lerp_angle(base.rotation, deg2rad(180), 0.5)
		frame += delta * 10
		position += Vector2(0, 50) * delta
	if frame > 2.0:
		frame = 0.0
	base.frame = int(round(frame))
	var world = get_parent()
	if position.x > world.space:
		position.x -= world.space * 2
	if position.x < -world.space:
		position.x += world.space * 2
	
	if position.y > world.space:
		position.y -= world.space * 2
	if position.y < -world.space:
		position.y += world.space * 2
	
	bicep.global_rotation = get_global_mouse_position().angle_to_point(bicep.global_position) + deg2rad(90)
	var overlap = clamp((34 - get_global_mouse_position().distance_to(global_position)) / 2, 0, 25)
	bicep.polygon = defPoly
	foreArm.polygon = defPoly
	var biPoly = bicep.polygon
	biPoly[2].x += overlap
	biPoly[2].y += overlap
	biPoly[3].x -= overlap
	biPoly[3].y += overlap
	bicep.polygon = biPoly
	var foPoly = foreArm.polygon
	foPoly[1].x += overlap
	foPoly[0].x -= overlap
	foPoly[3].y += overlap
	foPoly[2].y += overlap
	foreArm.position.y = -18 + overlap
	claw.position.y = -18 + overlap
	foreArm.polygon = foPoly
	
	if Input.is_action_just_pressed("follow"):
		if !claw.get_overlapping_areas().empty():
			inClaw = claw.get_overlapping_areas()[0]
	
	if Input.is_action_just_released("follow"):
		inClaw = null
	
	if is_instance_valid(inClaw):
		inClaw.global_position = claw.global_position
	
	if Input.is_action_pressed("follow"):
		clawVisual.frame = 1
	else:
		clawVisual.frame = 0
