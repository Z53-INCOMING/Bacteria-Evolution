extends Polygon2D

var quality = 96

var radius = 5

func _ready() -> void:
	var index = 0.0
	var poly = []
	
	for i in range(quality):
		poly.append(Vector2(cos(deg2rad(index)), sin(deg2rad(index))) * radius)
		index += 360.0 / quality
	
	polygon = poly
