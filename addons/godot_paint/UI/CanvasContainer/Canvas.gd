@tool
extends Panel

# It works, but the code isn't particularly pretty
const ZOOM_LEVEL = [1, 2, 3, 4, 6, 8, 12, 16, 20, 25, 33, 50, 100, 200, 300, 
400, 500, 600, 800, 1200, 1600, 2400, 3200, 4800, 6400]


@onready var texture := $CanvasTexture
@onready var zoom_out_button := $ZoomControls/HBoxContainer/ZoomOut
@onready var zoom_reset_button := $ZoomControls/HBoxContainer/ZoomReset
@onready var zoom_in_button := $ZoomControls/HBoxContainer/ZoomIn

@onready var h_scroll := %HScrollBar
@onready var v_scroll := %VScrollBar

#@onready var info_bar := %InfoBar

var _middle_mouse_pressed: bool
var _middle_mouse_drag_offset: Vector2

var _previous_mouse_position: Vector2

var _zoom_level_index := ZOOM_LEVEL.find(100):
	set(value):
		_zoom_level_index = clamp(value, 0, ZOOM_LEVEL.size() - 1)
		if texture:
			var _scale = zoom_level() / 100.0
	
			texture.scale = Vector2(_scale, _scale)
			
			if zoom_reset_button:
				zoom_reset_button.text = str(zoom_level()) + " %"
			
			update_scroll_bars()


func _ready():
	zoom_out_button.icon = get_theme_icon("ZoomLess", "EditorIcons")
	zoom_reset_button.text = str(zoom_level()) + " %"
	zoom_in_button.icon = get_theme_icon("ZoomMore", "EditorIcons")
	
	if texture.size == Vector2.ZERO:
		v_scroll.hide()
		h_scroll.hide()
	else:
		v_scroll.show()
		h_scroll.show()
		
		texture.pivot_offset = texture.size / 2
		
		update_scroll_bars()


func update_scroll_bars():
	var rect = get_canvas_limits()
	
	if texture.size.x * texture.scale.x >= size.x:
		h_scroll.min_value = -rect.end.x
		h_scroll.max_value = -rect.position.x + size.x
		
		h_scroll.page = size.x
		
		h_scroll.value = -texture.position.x
	else:
		h_scroll.min_value = rect.position.x
		h_scroll.max_value = rect.end.x + (texture.size.x * (zoom_level() / 100.0))
		
		h_scroll.page = texture.size.x * (zoom_level() / 100.0)
		
		h_scroll.value = texture.position.x
	
	if texture.size.y * texture.scale.y >= size.y:
		v_scroll.min_value = -rect.end.y
		v_scroll.max_value = -rect.position.y + size.y
		
		v_scroll.page = size.y
		
		v_scroll.value = -texture.position.y
	else:
		v_scroll.min_value = rect.position.y
		v_scroll.max_value = rect.end.y + (texture.size.y * (zoom_level() / 100.0))
		
		v_scroll.page = texture.size.y * (zoom_level() / 100.0)
		
		v_scroll.value = texture.position.y


func _on_canvas_gui_input(event):
	var previous_position = texture.position
	
	if event is InputEventMouseMotion:
		_previous_mouse_position = event.position
		if _middle_mouse_pressed:
			texture.position = event.position + _middle_mouse_drag_offset
		
		var p = ((event.position - texture.position + texture.pivot_offset * texture.scale - texture.pivot_offset) / texture.scale).floor()
		
		var rect = Rect2(Vector2.ZERO, texture.size)
		
#		info_bar.set_mouse_position(Vector2i(p))
#
#		if rect.has_point(p):
#			info_bar.set_mouse_position_color(get_theme_color("font_color", "Editor"))
#		else:
#			info_bar.set_mouse_position_color(get_theme_color("disabled_font_color", "Editor"))
		
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_MIDDLE:
				if event.pressed and not _middle_mouse_pressed:
					_middle_mouse_pressed = true
					_middle_mouse_drag_offset = texture.position - event.position
				elif not event.pressed and _middle_mouse_pressed:
					_middle_mouse_pressed = false
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed and not _middle_mouse_pressed:
					_zoom_out()
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed and not _middle_mouse_pressed:
					_zoom_in()
	
	clamp_canvas()
	update_scroll_bars()


func get_canvas_rect() -> Rect2:
	return Rect2(
		texture.position - texture.pivot_offset * texture.scale + texture.pivot_offset,
		texture.size * texture.scale,
	)


func get_canvas_limits() -> Rect2:
	# The top left constraint of canvas position
	var top_left = texture.pivot_offset * texture.scale - texture.pivot_offset
	# The bottom right constraint of canvas position
	var bottom_right = -texture.size * texture.scale + texture.pivot_offset * texture.scale + size - texture.pivot_offset
	
	var half_screen = size / 2
	
	var rect = Rect2(top_left, bottom_right - top_left)
	
	var diff = texture.size * texture.scale - half_screen
	
	# If wider or longer than screen, extend constraints to half the current
	# screen size
	# If wider of longer than half the screen, extend constrains to size - half screen
	if texture.size.x * texture.scale.x >= size.x:
		rect.position.x = bottom_right.x - half_screen.x
		rect.end.x = top_left.x + half_screen.x
	elif diff.x > 0:
		rect = rect.grow_individual(diff.y, 0, diff.y, 0)
	if texture.size.y * texture.scale.y >= size.y:
		rect.position.y =  bottom_right.y - half_screen.y
		rect.end.y = top_left.y + half_screen.y
	elif diff.y > 0:
		rect = rect.grow_individual(0, diff.y, 0, diff.y)
	
	return rect


func clamp_canvas():
	var previous_position = texture.position
	
	var limits = get_canvas_limits()
	
	texture.position = texture.position.clamp(limits.position, limits.end)
	
	if not texture.position == previous_position:
		_middle_mouse_drag_offset = texture.position - _previous_mouse_position


func zoom_level() -> int:
	return ZOOM_LEVEL[_zoom_level_index]


func _zoom_out():
	_zoom_level_index -= 1


func _zoom_reset():
	_zoom_level_index = ZOOM_LEVEL.find(100)


func _zoom_in():
	_zoom_level_index += 1


func _on_canvas_resized():
	clamp_canvas()


func _on_h_scroll_bar_scrolling():
	texture.position.x = h_scroll.value * (-1 if texture.size.x * texture.scale.x >= size.x else 1)


func _on_v_scroll_bar_scrolling():
	texture.position.y = v_scroll.value * (-1 if texture.size.y * texture.scale.y >= size.y else 1)
