@tool
extends PanelContainer

@onready var flow_container = $HFlowContainer

@onready var palette_color_button = preload("res://addons/godot_paint/UI/palette_color_button.tscn")

signal left_click(color_button)
signal right_click(color_button)

var colors: PackedColorArray = []

func _ready():
	_on_settings_changed()

func add_color(color):
	colors.append(color)
	
	var color_button = palette_color_button.instantiate()
	color_button.icon = color_button.icon.duplicate(true)
	color_button.color = color
	
	flow_container.add_child(color_button)
	
	color_button.left_click.connect(_on_color_left_click.bind(color_button))
	color_button.right_click.connect(_on_color_right_click.bind(color_button))


func _on_color_left_click(color_button):
	left_click.emit(color_button)

func _on_color_right_click(color_button):
	right_click.emit(color_button)


func _on_settings_changed():
	add_theme_stylebox_override("panel", get_theme_stylebox("panel", "Panel"))
	var stylebox: StyleBoxFlat = get_theme_stylebox("panel", "Panel")
