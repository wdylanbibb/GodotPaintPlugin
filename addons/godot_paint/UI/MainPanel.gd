@tool
extends PanelContainer

signal settings_changed()


func _ready():
	_on_settings_changed()


var editor_base_control: Control:
	set(value):
		editor_base_control = value
		editor_base_control.connect("theme_changed", theme_changed)


func theme_changed():
	settings_changed.emit()


func _on_settings_changed():
	add_theme_stylebox_override("panel", get_theme_stylebox("ScriptEditorPanel", "EditorStyles"))
