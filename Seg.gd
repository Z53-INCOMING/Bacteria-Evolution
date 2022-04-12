extends PathFollow2D

var segID = 0

func _ready() -> void:
	segID = 10 - get_position_in_parent()

func _process(delta: float) -> void:
	if segID == 10:
		unit_offset = 1.0
	else:
		unit_offset = float("0." + str(segID))
	rotation_degrees += 180
