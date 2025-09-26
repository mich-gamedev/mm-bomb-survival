extends Node2D

func set_color(color: Color) -> void:
	for i in [$Body, $Body2, $Body3]:
		if i is RingDraw:
			i.fill_color = color
			i.draw_color = color
		elif i is ColorRect:
			i.color = color
