@tool
extends PopupMenu

# For items that affect the File Manager and general Plugin things

enum {
	NEW_FILE = 0,
	LOAD_FILE = 1,
	SAVE_FILE = 3,
	SAVE_FILE_AS = 4,
	CLOSE_FILE = 5,
	CLOSE_ALL_FILES = 6,
}

signal new_file()
signal load_file()
signal save_file()
signal save_file_as()
signal close_file()
signal close_all_files()

# TODO: Get shortcuts working (plugin does not take precedent over engine)
func _ready() -> void:
	set_item_accelerator(NEW_FILE, KEY_N | KEY_MASK_CTRL)
	set_item_shortcut(LOAD_FILE, get_shortcut(KEY_O | KEY_MASK_CTRL))
	set_item_shortcut(SAVE_FILE, get_shortcut(KEY_S | KEY_MASK_CTRL))
	set_item_shortcut(SAVE_FILE_AS, get_shortcut(KEY_S | KEY_MASK_CTRL | KEY_MASK_SHIFT))
	set_item_shortcut(CLOSE_FILE, get_shortcut(KEY_W | KEY_MASK_CTRL))
	set_item_shortcut(CLOSE_ALL_FILES, get_shortcut(KEY_W | KEY_MASK_CTRL | KEY_MASK_SHIFT))


func _on_id_pressed(id: int):
	match id:
		NEW_FILE:
			new_file.emit()
		LOAD_FILE:
			load_file.emit()
		SAVE_FILE:
			save_file.emit()
		SAVE_FILE_AS:
			save_file_as.emit()
		CLOSE_FILE:
			close_file.emit()
		CLOSE_ALL_FILES:
			close_all_files.emit()


func get_shortcut(key: int):
	var shortcut = Shortcut.new()
	var event = InputEventKey.new()
	event.keycode = key
	
	shortcut.events = [event]
	return shortcut
