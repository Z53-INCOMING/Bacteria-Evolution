extends Node2D

func _ready() -> void:
	var space = Globals.mapSize
	
	$LBorder.rect_position = Vector2(-space - 1, -space)
	$LBorder.rect_size = Vector2(2, (space * 2) + 1)
	$RBorder.rect_position = Vector2(space - 1, -space)
	$RBorder.rect_size = Vector2(2, space * 2)
	$TBorder.rect_position = Vector2(-space, -space)
	$TBorder.rect_size = Vector2(space * 2, 2)
	$BBorder.rect_position = Vector2(-space, space - 1)
	$BBorder.rect_size = Vector2((space * 2) + 1, 2)
	
	$LBorder2.rect_position = Vector2(-space - 300, -space)
	$LBorder2.rect_size = Vector2(300, (space * 2) + 1)
	$RBorder2.rect_position = Vector2(space - 1, -space)
	$RBorder2.rect_size = Vector2(300, space * 2)
	$TBorder2.rect_position = Vector2(-space, -space - 300)
	$TBorder2.rect_size = Vector2(space * 2, 300)
	$BBorder2.rect_position = Vector2(-space, space - 1)
	$BBorder2.rect_size = Vector2((space * 2) + 1, 300)
