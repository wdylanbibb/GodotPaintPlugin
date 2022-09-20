@tool
extends PanelContainer


@onready var brush_button := $VBoxContainer/Brush
@onready var eyedropper_button := $VBoxContainer/Eyedropper


func _ready():
	_on_settings_changed()


func _on_settings_changed():
	add_theme_stylebox_override("panel", get_theme_stylebox("panel", "Panel"))
	
	brush_button.icon = get_theme_icon("CanvasItem", "EditorIcons")
	eyedropper_button.icon = get_theme_icon("ColorPick", "EditorIcons")
