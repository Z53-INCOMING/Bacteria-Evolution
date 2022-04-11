extends Area2D

export var bluePortalPath: NodePath = "/"

var bluePortal = null

onready var output = $output

func _ready() -> void:
	bluePortal = get_node(bluePortalPath)

func _on_OrangePortal_area_entered(area: Area2D) -> void:
	var s = area.scale
	area.global_transform = bluePortal.output.global_transform
	area.scale = s
