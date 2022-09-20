@tool
extends Button

signal left_click
signal right_click

@export var color := Color.BLACK:
	set(value):
		color = value
		icon.gradient.colors = [value]


func _on_palette_color_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
			MOUSE_BUTTON_RIGHT:
				right_click.emit()
