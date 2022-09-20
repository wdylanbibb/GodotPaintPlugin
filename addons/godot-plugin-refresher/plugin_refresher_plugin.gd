@tool
extends EditorPlugin

const ADDONS_PATH = "res://addons/"
const PLUGIN_CONFIG_DIR = "plugins/plugin_refresher"
const PLUGIN_CONFIG = "settings.cfg"
const SETTINGS = "settings"
const SETTING_RECENT = "recently_used"

var plugin_config = ConfigFile.new()
var refresher

func _enter_tree():
	refresher = preload("plugin_refresher.tscn").instantiate()
	add_control_to_container(CONTAINER_TOOLBAR, refresher)

	# Watch whether any plugin is changed, added or removed on the filesystem
	var efs = get_editor_interface().get_resource_filesystem()
	efs.connect("filesystem_changed", _on_filesystem_changed)

	refresher.connect("request_refresh_plugin", _on_request_refresh_plugin)
	refresher.connect("confirm_refresh_plugin", _on_confirm_refresh_plugin)

	_reload_plugins_list()


func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, refresher)
	refresher.free()


func _reload_plugins_list():
	var refresher_dir = get_plugin_path().get_file()
	var plugins = {}
	var origins = {}

	var dir = Directory.new()
	dir.open(ADDONS_PATH)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file:
		var addon_dir = ADDONS_PATH.path_join(file)
		if dir.dir_exists(addon_dir) and file != refresher_dir:
			var display_name = file
			var plugin_config_path = addon_dir.path_join("plugin.cfg")
			if not dir.file_exists(plugin_config_path):
				file = dir.get_next()
				continue # not a plugin
			var plugin_cfg = ConfigFile.new()
			plugin_cfg.load(plugin_config_path)
			display_name = plugin_cfg.get_value("plugin", "name", file)
			if not display_name in origins:
				origins[display_name] = [file]
			else:
				origins[display_name].append(file)
			plugins[file] = display_name
		file = dir.get_next()

	# Specify the exact plugin name in parenthesis in case of naming collisions.
	for display_name in origins:
		var plugin_names = origins[display_name]
		if plugin_names.size() > 1:
			for n in plugin_names:
				plugins[n] = "%s (%s)" % [display_name, n]

	refresher.update_items(plugins)


func _on_filesystem_changed():
	if refresher:
		_reload_plugins_list()
		refresher.select_plugin(get_recent_plugin())


func get_recent_plugin():
	if not plugin_config.has_section_key(SETTINGS, SETTING_RECENT):
		return null # not saved yet

	var recent = plugin_config.get_value(SETTINGS, SETTING_RECENT)
	return recent


func _on_request_refresh_plugin(p_name):
	assert(not p_name.is_empty())

	var disabled = not get_editor_interface().is_plugin_enabled(p_name)
	if disabled:
		refresher.show_warning(p_name)
	else:
		refresh_plugin(p_name)


func _on_confirm_refresh_plugin(p_name):
	refresh_plugin(p_name)


func get_plugin_path():
	return get_script().resource_path.get_base_dir()


func refresh_plugin(p_name):
	print("Refreshing plugin: ", p_name)

	var enabled = get_editor_interface().is_plugin_enabled(p_name)
	if enabled: # can only disable an active plugin
		get_editor_interface().set_plugin_enabled(p_name, false)

	get_editor_interface().set_plugin_enabled(p_name, true)
