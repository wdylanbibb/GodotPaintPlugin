@tool
extends HBoxContainer

@onready var canvas_texture := $VBoxContainer/Canvas/CanvasTexture

var _image: Image


func load_from_texture(texture: Texture):
	pass


func load_from_path(path: String):
	pass


func create_empty(image_size: Vector2i):
	var i = Image.new()
	i.create(image_size.x, image_size.y, true, Image.FORMAT_RGBA8)
	
	_image = i
	
	var itex = ImageTexture.create_from_image(_image)
	canvas_texture.texture = itex
	


func load_from_image(image: Image):
	pass
