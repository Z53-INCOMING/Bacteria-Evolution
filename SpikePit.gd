extends Area2D
var energy = -30.0


func _on_SpikePit_area_entered(area: Area2D) -> void:
	get_parent().message(area.name + " was fooled.")
