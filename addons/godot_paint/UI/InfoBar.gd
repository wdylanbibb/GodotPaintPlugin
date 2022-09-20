@tool
extends HBoxContainer

@onready var mouse_icon_texture_rect := $MousePosition/MouseIconTexture
@onready var mouse_position_label := $MousePosition/MousePositionLabel

@onready var image_size_texture := $ImageSize/SizeIconTexture
@onready var image_size_label := $ImageSize/ImageSizeLabel


func _ready():
	_on_settings_changed()


func set_mouse_position(pos: Vector2i):
	mouse_position_label.text = str(pos.x) + ", " + str(pos.y)

func set_mouse_position_color(color: Color):
	mouse_position_label.add_theme_color_override("font_color", color)


func _on_settings_changed():
	mouse_icon_texture_rect.texture = get_theme_icon("EditPivot", "EditorIcons")
	image_size_texture.texture = get_theme_icon("2D", "EditorIcons")
