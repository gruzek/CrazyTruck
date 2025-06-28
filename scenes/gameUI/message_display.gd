extends Control
@onready var fade_timer = $FadeTimer
@onready var sequence_timer: Timer = $SequenceTimer
@onready var anim_player = $AnimationPlayer
@onready var label: Label = $MessageLabel

@export var messages: Array[String] = []
@export var display_duration := 2.0  # Seconds to show message before fading
@export var sequence_duration := 6.0  # Seconds between the start display of messages
@export var auto_start := true

var _index := 0

func _ready():
	fade_timer.timeout.connect(_on_fade_timer_timeout)
	if auto_start:
		start_sequence()

func start_sequence():
	_index = 0

	sequence_timer.timeout.connect(_on_sequence_timer_timeout)
	show_next_message()

func show_next_message():
	if _index >= messages.size():
		return
		
	show_message(messages[_index])
	sequence_timer.start(sequence_duration)
	_index += 1

func _on_sequence_timer_timeout():
	show_next_message()
	
func show_message(text: String):
	label.text = text
	# label.modulate.a = 1.0
	visible = true
	fade_timer.start(display_duration)

func _on_fade_timer_timeout() -> void:
	# fix this later
	#anim_player.play("fade_out")
	visible = false
