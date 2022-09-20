@tool
extends MarginContainer

signal settings_changed()


var editor_base_control: Control:
	set(value):
		editor_base_control = value
		editor_base_control.connect("theme_changed", theme_changed)


func theme_changed():
	settings_changed.emit()
