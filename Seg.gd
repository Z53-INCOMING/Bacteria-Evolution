extends PathFollow2D

var segID = 0.0

onready var visual = $Visual

func _ready() -> void:
	segID = float(get_parent().get_child_count() - get_position_in_parent())
	if name != "Head":
		name = "Seg" + str(segID)

func _process(delta: float) -> void:
	segID = float(get_parent().get_child_count() - get_position_in_parent())
	if (segID / 10.0) == 0.0:
		unit_offset = 0.0
	else:
		unit_offset = (1.0 / get_parent().get_child_count()) * segID
	if get_position_in_parent() + 2 > get_parent().get_child_count() - 1:
		if get_position_in_parent() == get_parent().get_child_count() - 1:
			visual.frame = 3
			visual.position.x = 5
		if get_position_in_parent() + 1 == get_parent().get_child_count() - 1:
			visual.frame = 2
			visual.position.x = 6
	else:
		visual.frame = 1
		visual.position.x = 7
	if get_position_in_parent() == 0:
		visual.frame = 0
		visual.position.x = 8
	rotation_degrees += 180
