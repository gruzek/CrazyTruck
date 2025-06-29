extends Node3D

@onready var game_ui: CanvasLayer = $GameUi
@onready var message_display: Control = $GameUi/MessageDisplay
@onready var malfunction_icon: Control = $GameUi/MalfunctionIcon

var _nitrous_messages : Array[String] = [
	"Smelling some Nitro", 
	"Uh oh, Go Go Juice Leaking", 
	"Let's Truckin GO!"]
var _brake_messages : Array[String] = [
	"Who needs Brake Rotors", 
	"Slowing Down is for Wimps", 
	"I Brake for ... Nothing"]
var _thrust_messages : Array[String] = [
	"No Gas. No Gas. No Gas.", 
	"Come on Bessie, Don't Stop Now", 
	"Where did I put that Gas Pedal?"]
var _steering_messages : Array[String] = [
	"Warning: Squirrel Steering Ahead",
	"Truck Feelin' Interpretive",
	"Go Left! No Right! oh whatever"
]
var _normal_messages : Array[String] = [
	"Ok, I think it works again",
	"Truckin' OK",
	"Truck Yeah!"
]

func _random_message(messages: Array[String]) -> String:
	return messages[randi_range(0,messages.size()-1)]
	
func nitrous_message() -> void:
	message_display.show_message(_random_message(_nitrous_messages))	

func brake_message() -> void:
	message_display.show_message(_random_message(_brake_messages))	
	
func thrust_message() -> void:
	message_display.show_message(_random_message(_thrust_messages))	
	
func steering_message() -> void:
	message_display.show_message(_random_message(_steering_messages))	

func normal_message() -> void:
	malfunction_icon.hide_all_icons()
	message_display.show_message(_random_message(_normal_messages))
	
func _ready():
	# message_display.show_message("Get to the end!!")
	randomize()
