@tool
extends PanelContainer

@onready var color_picker_foreground := $VBoxContainer/HBoxContainer/ForegroundColorPicker
@onready var warning_button_foreground := $VBoxContainer/HBoxContainer/ForegroundAddColorButton

@onready var color_picker_background := $VBoxContainer/HBoxContainer2/BackgroundColorPicker
@onready var warning_button_background := $VBoxContainer/HBoxContainer2/BackgroundAddColorButton

@onready var palette := %Palette

func _ready():
	_on_settings_changed()


func _on_foreground_color_picker_color_changed(color):
	if color in palette.colors and warning_button_foreground.visible:
		warning_button_foreground.hide()
	
	if not color in palette.colors and not warning_button_foreground.visible:
		warning_button_foreground.show()


func _on_foreground_add_color_button_pressed():
	palette.add_color(color_picker_foreground.color)
	warning_button_foreground.hide()
	
	if color_picker_background.color == color_picker_foreground.color:
		warning_button_background.hide()


func _on_background_color_picker_color_changed(color):
	if color in palette.colors and warning_button_background.visible:
		warning_button_background.hide()
	
	if not color in palette.colors and not warning_button_background.visible:
		warning_button_background.show()


func _on_background_add_color_button_pressed():
	palette.add_color(color_picker_background.color)
	warning_button_background.hide()
	
	if color_picker_background.color == color_picker_foreground.color:
		warning_button_foreground.hide()


func _on_palette_left_click(color_button):
	color_picker_foreground.color = color_button.color
	_on_foreground_color_picker_color_changed(color_button.color)


func _on_palette_right_click(color_button):
	color_picker_background.color = color_button.color
	_on_background_color_picker_color_changed(color_button.color)


func _on_settings_changed():
	add_theme_stylebox_override("panel", get_theme_stylebox("panel", "Panel"))
	
	warning_button_foreground.icon = get_theme_icon("StatusWarning", "EditorIcons")
	warning_button_background.icon = get_theme_icon("StatusWarning", "EditorIcons")
