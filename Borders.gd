extends Node2D

export var thickness = 20

func _ready() -> void:
	var space = Globals.mapSize
	
	$LBorder.rect_position = Vector2(-space, -space)
	$LBorder.rect_size = Vector2(thickness, (space * 2))
	$RBorder.rect_position = Vector2(space - thickness, -space)
	$RBorder.rect_size = Vector2(thickness, space * 2)
	$TBorder.rect_position = Vector2(-space, -space - thickness)
	$TBorder.rect_size = Vector2((space * 2), thickness)
	$BBorder.rect_position = Vector2(-space, space - thickness)
	$BBorder.rect_size = Vector2((space * 2), thickness)
	
#	$LBorder2.rect_position = Vector2(-space - 300, -space)
#	$LBorder2.rect_size = Vector2(300, (space * 2) + thickness)
#	$RBorder2.rect_position = Vector2(space - thickness, -space)
#	$RBorder2.rect_size = Vector2(300, space * 2)
#	$TBorder2.rect_position = Vector2(-space, -space - 300)
#	$TBorder2.rect_size = Vector2(space * 2, 300)
#	$BBorder2.rect_position = Vector2(-space, space - thickness)
#	$BBorder2.rect_size = Vector2((space * 2) + thickness, 300)
