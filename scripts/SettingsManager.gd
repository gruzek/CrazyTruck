class_name SettingsManager

# Default settings
static var default_settings = {
	"display": {
		"resolution": Vector2i(1920, 1080),
		"fullscreen": false
	}
}

# Current settings
static var current_settings = default_settings

# Load settings from file
static func load_settings():
	var file = File.new()
	if file.file_exists("user://settings.json"):
		file.open("user://settings.json", File.READ)
		var json = JSON.new()
		var result = json.parse(file.get_as_text())
		if result.error == OK:
			current_settings = json.get_data()
		file.close()

# Save settings to file
static func save_settings():
	var file = File.new()
	file.open("user://settings.json", File.WRITE)
	var json = JSON.new()
	json.parse_error = JSON.Error.ERROR_NULL
	var text = json.stringify(current_settings)
	file.store_string(text)
	file.close()

# Update display settings
static func update_display_settings(resolution: Vector2i, fullscreen: bool):
	current_settings.display.resolution = resolution
	current_settings.display.fullscreen = fullscreen
	save_settings()
	apply_display_settings()

# Apply current display settings
static func apply_display_settings():
	var window = get_window()
	window.size = current_settings.display.resolution
	window.fullscreen = current_settings.display.fullscreen
