extends Node3D

@onready var man_01: MeshInstance3D = $"person-01/man-01"
@onready var woman_01: MeshInstance3D = $"person-01/woman-01"

func _ready():
	# Randomly choose man or woman
	if randf() < 0.4:
		man_01.visible = true
		woman_01.visible = false
	else:
		man_01.visible = false
		woman_01.visible = true
