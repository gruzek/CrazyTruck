extends Control

signal restart_game
signal go_to_main_menu

@onready var restart_button = $VBoxContainer/RestartLevelButton
@onready var menu_button = $VBoxContainer/MainMenuButton
@onready var game_over_label: Label = $VBoxContainer/GameOverLabel

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false  # Start hidden
	restart_button.pressed.connect(emit_restart)
	menu_button.pressed.connect(emit_main_menu)

func game_over_clobbered():
	show_game_over('They are Clobbered')
	
func show_game_over(message: String):
	game_over_label.text = message
	visible = true
	get_tree().paused = true  # Pause the game

func emit_restart():
	print("restart pressed")
	get_tree().paused = false
	emit_signal("restart_game")
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()

func emit_main_menu():
	get_tree().paused = false
	emit_signal("go_to_main_menu")
	get_tree().change_scene_to_file("res://scenes/intro/MainMenu.tscn")
