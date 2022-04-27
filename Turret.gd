extends Node2D

onready var head = $head

var target = null

var firing = false

onready var laser = $head/Line2D
onready var ray = $head/RayCast2D

func _process(_delta: float) -> void:
	get_tree().paused = false
	$Camera2D.current = true
#	var shortestDst = 99999
#	var closestTarget = null
#	for possibleTarget in get_overlapping_areas():
#		if !possibleTarget.is_in_group("marked"):
#			if possibleTarget.global_position.distance_to(global_position) < shortestDst:
#				shortestDst = possibleTarget.global_position.distance_to(global_position)
#				closestTarget = possibleTarget
#	target = closestTarget
#	if is_instance_valid(target):
#		head.rotation = target.global_position.angle_to_point(global_position)
#		firing = true
	head.look_at(get_global_mouse_position())
	firing = Input.is_action_pressed("follow")
	
	if firing:
		laser.points[1].x = 305
		if ray.is_colliding():
			laser.points[1].x = ray.get_collision_point().distance_to(laser.global_position)
			if is_instance_valid(ray.get_collider()):
				ray.get_collider().health -= 1
	else:
		laser.points[1].x = 0
