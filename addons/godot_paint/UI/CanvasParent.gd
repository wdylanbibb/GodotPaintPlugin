@tool
extends HBoxContainer


const CanvasContainer = preload("res://addons/godot_paint/UI/CanvasContainer/CanvasContainer.tscn")


func add_canvas_from_size(canvas_size: Vector2):
	var canvas_container = CanvasContainer.instantiate()
	add_child(canvas_container)
	
	canvas_container.create_empty(canvas_size)

