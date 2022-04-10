extends Area2D

onready var head = $head

var target = null

var firing = false

onready var laser = $head/Line2D
onready var ray = $head/RayCast2D

func _process(_delta: float) -> void:
	firing = false
	var shortestDst = 99999
	var closestTarget = null
	for possibleTarget in get_overlapping_areas():
		if !possibleTarget.is_in_group("marked"):
			if possibleTarget.global_position.distance_to(global_position) < shortestDst:
				shortestDst = possibleTarget.global_position.distance_to(global_position)
				closestTarget = possibleTarget
	target = closestTarget
	if is_instance_valid(target):
		head.rotation = target.global_position.angle_to_point(global_position)
		firing = true
	
	if firing:
		laser.points[1].x = 305
		if ray.is_colliding():
			laser.points[1].x = ray.get_collision_point().distance_to(laser.global_position)
			if is_instance_valid(ray.get_collider()):
				var targetName = ray.get_collider().name
				get_parent().message(targetName + " got vaporized.")
				ray.get_collider().queue_free()
			firing = false
	else:
		laser.points[1].x = 0
