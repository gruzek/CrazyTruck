extends Control

func _ready():
	$CenterContainer/VBoxContainer/NewGameButton.pressed.connect(_on_new_game_pressed)
	$CenterContainer/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/worldMap/StrategicMap.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/settings/SettingsMenu.tscn")

func _on_exit_pressed():
	get_tree().quit()
