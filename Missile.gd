extends Area2D

var velocity = Vector2(0, 0)

onready var homing = $homingArea

onready var particles = $Particles2D

var target = null

var shouldEmit = true

func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second()
	if fps < 15:
		shouldEmit = false
	if fps > 45:
		shouldEmit = true
	particles.emitting = shouldEmit
	if !get_tree().paused:
		position += velocity * delta
		if !is_instance_valid(target):
			var shortestDst = 99999
			var closestTarget = null
			for possibleTarget in homing.get_overlapping_areas():
				if !possibleTarget.is_in_group("marked"):
					if possibleTarget.global_position.distance_to(global_position) < shortestDst:
						shortestDst = possibleTarget.global_position.distance_to(global_position)
						closestTarget = possibleTarget
			target = closestTarget
		else:
			velocity += (target.position - position).normalized() * 80 * delta
		rotation = velocity.angle()
		var world = get_parent()
		if position.x > world.space:
			position.x -= world.space * 2
		if position.x < -world.space:
			position.x += world.space * 2
		
		if position.y > world.space:
			position.y -= world.space * 2
		if position.y < -world.space:
			position.y += world.space * 2


func _on_Missile_area_entered(area: Area2D) -> void:
	if !area.is_in_group("marked"):
		area.food = 0.0
		area.health = 0
		queue_free()


