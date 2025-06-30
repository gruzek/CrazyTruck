extends Control
@onready var lets_trucking_go: AudioStreamPlayer2D = $LetsTruckingGo

func _ready():
	$CenterContainer/VBoxContainer/NewGameButton.pressed.connect(_on_new_game_pressed)
	$CenterContainer/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/level-01/level-01.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/settings/SettingsMenu.tscn")

func _on_exit_pressed():
	get_tree().quit()


func _on_lets_trucking_go_timer_timeout() -> void:
	lets_trucking_go.play() # Replace with function body.
