extends Node

@export var messages: Array[String] = []
@export var delay_between_messages := 2.0
@export var auto_start := true

@onready var message_display := $"../MessageDisplay"  # or preload a global one
@onready var timer := Timer.new()

var index := 0

func _ready():
	if auto_start:
		start_sequence()

func start_sequence():
	if not is_instance_valid(message_display):
		push_warning("MessageDisplay not found.")
		return

	index = 0
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	show_next_message()

func show_next_message():
	if index >= messages.size():
		timer.queue_free()
		return
	message_display.show_message(messages[index])
	timer.start(delay_between_messages)
	index += 1

func _on_timeout():
	show_next_message()
