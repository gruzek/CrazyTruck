extends Control

@export var countdown_time: int = 120  # total seconds (e.g. 2 minutes)
@onready var countdown_label: Label = $Label

var _time_left: float = 0.0
var _active: bool = false

func _ready():
	start_timer()

func start_timer():
	_time_left = countdown_time
	_active = true
	update_label()

func _process(delta):
	if _active:
		_time_left -= delta
		if _time_left <= 0:
			_time_left = 0
			_active = false
			on_time_up()
		update_label()

func update_label():
	var total_seconds := int(_time_left)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	countdown_label.text = "%02d:%02d" % [minutes, seconds]

func on_time_up():
	print("⏰ Time is up!")
	# trigger game over logic, show message, etc.
