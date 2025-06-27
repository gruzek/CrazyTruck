extends Control

const RESOLUTIONS = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

@onready var resolution_option = %ResolutionOption
@onready var fullscreen_check = %FullscreenCheck

func _ready():
	_setup_resolution_options()
	_load_current_settings()
	$CenterContainer/VBoxContainer/ButtonsContainer/ApplyButton.pressed.connect(_on_apply_pressed)
	$CenterContainer/VBoxContainer/ButtonsContainer/BackButton.pressed.connect(_on_back_pressed)

func _setup_resolution_options():
	for resolution in RESOLUTIONS:
		resolution_option.add_item("%dx%d" % [resolution.x, resolution.y])

func _load_current_settings():
	var window = get_window()
	var current_res = window.size
	fullscreen_check.button_pressed = window.mode == Window.MODE_FULLSCREEN
	
	for i in range(RESOLUTIONS.size()):
		if RESOLUTIONS[i] == current_res:
			resolution_option.selected = i
			break

func _on_apply_pressed():
	var selected_res = RESOLUTIONS[resolution_option.selected]
	var is_fullscreen = fullscreen_check.button_pressed
	var window = get_window()
	window.size = selected_res
	if is_fullscreen:
		window.mode = Window.MODE_FULLSCREEN 
	else:
		window.mode = Window.MODE_WINDOWED

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/intro/MainMenu.tscn")
