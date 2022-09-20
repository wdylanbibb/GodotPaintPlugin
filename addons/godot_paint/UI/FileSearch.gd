@tool
extends LineEdit

func _ready():
	_on_settings_changed()


func _on_settings_changed():
	right_icon = get_theme_icon("Search", "EditorIcons")
