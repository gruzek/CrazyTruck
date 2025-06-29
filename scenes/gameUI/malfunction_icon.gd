extends Control
@onready var thrust_icon: TextureRect = $ThrustIcon
@onready var brake_icon: TextureRect = $BrakeIcon
@onready var nitrous_icon: TextureRect = $NitrousIcon
@onready var steering_icon: TextureRect = $SteeringIcon

func show_thrust_icon() -> void:
	thrust_icon.visible = true

func show_brake_icon() -> void:
	thrust_icon.visible = true

func show_nitrous_icon() -> void:
	nitrous_icon.visible = true
	
func show_steering_icon() -> void:
	steering_icon.visible = true
	
func hide_all_icons() -> void:
	thrust_icon.visible = false
	thrust_icon.visible = false
	nitrous_icon.visible = false
	steering_icon.visible = false
