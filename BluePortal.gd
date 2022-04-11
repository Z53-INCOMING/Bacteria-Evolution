extends Area2D

export var orangePortalPath: NodePath = "/"

var orangePortal = null

onready var output = $output

func _ready() -> void:
	orangePortal = get_node(orangePortalPath)

func _on_BluePortal_area_entered(area: Area2D) -> void:
	var s = area.scale
	area.global_transform = orangePortal.output.global_transform
	area.scale = s
