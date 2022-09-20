@tool
extends EditorPlugin

const MainPanel = preload("res://addons/godot_paint/UI/main_panel.tscn")

var main_panel_instance


func _enter_tree():
	# Initialization of the plugin goes here.
	main_panel_instance = MainPanel.instantiate()
	main_panel_instance.editor_base_control = get_editor_interface().get_base_control()
	
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)


func _exit_tree():
	# Clean-up of the plugin goes here.
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _forward_canvas_gui_input(event):
	return true


func _get_plugin_name():
	return "Paint"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("CanvasLayer", "EditorIcons")
