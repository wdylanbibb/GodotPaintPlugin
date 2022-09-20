@tool
extends PanelContainer

@onready var add_color_button := $HBoxContainer/AddColor
@onready var duplicate_color_button := $HBoxContainer/DuplicateColor
@onready var delete_color_options := $HBoxContainer/DeleteColor
@onready var options_menu := $HBoxContainer/Options

@onready var palette := %Palette

func _ready():
	_on_settings_changed()


func _on_add_color_pressed():
	palette.add_color(Color.WHITE)


func _on_settings_changed():
	add_color_button.icon = get_theme_icon("Add", "EditorIcons")
	duplicate_color_button.icon = get_theme_icon("Duplicate", "EditorIcons")
	delete_color_options.icon = get_theme_icon("Remove", "EditorIcons")
	options_menu.icon = get_theme_icon("GuiTabMenuHl", "EditorIcons")
