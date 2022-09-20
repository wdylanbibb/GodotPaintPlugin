@tool
extends MenuBar


@onready var new_file_dialog = $"../../NewFileDialog"


func _on_new_file():
	new_file_dialog.popup_centered()


func _on_new_file_dialog_size_confirmed(image_size):
	print(image_size)
