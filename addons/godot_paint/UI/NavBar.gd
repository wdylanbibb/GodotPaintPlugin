@tool
extends MenuBar


@onready var new_file_dialog = $"../../NewFileDialog"
@onready var canvas_parent = $"../HSplitContainer/HBoxContainer/CanvasParent"


func _on_new_file():
	new_file_dialog.popup_centered()


func _on_new_file_dialog_size_confirmed(image_size):
	canvas_parent.add_canvas_from_size(image_size)
