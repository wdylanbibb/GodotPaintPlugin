@tool
extends ConfirmationDialog

@onready var width_input := $VBoxContainer/HBoxContainer/SpinBox
@onready var height_input := $VBoxContainer/HBoxContainer2/SpinBox

signal size_confirmed(image_size)


func _on_confirmed():
	size_confirmed.emit(Vector2(width_input.value, height_input.value))
