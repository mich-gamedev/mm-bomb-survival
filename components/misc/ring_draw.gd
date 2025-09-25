@tool
class_name RingDraw extends Node2D

#@export var active: bool = true
@export var width : float = 4.0:
	set(v):
		width = v
		queue_redraw()
@export var radius : float = 24.0:
	set(v):
		radius = v
		queue_redraw()
@export var draw_color: Color = Color("f5ffe8"):
	set(v):
		draw_color = v
		queue_redraw()
@export var fill_color: Color = Color(1, 1, 1, 0):
	set(v):
		fill_color = v
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(), radius, fill_color)
	if width != 0:
		draw_circle(Vector2(), radius, draw_color, false, width)
