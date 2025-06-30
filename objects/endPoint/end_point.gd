extends Node3D
@onready var winning_audio: AudioStreamPlayer3D = $WinningAudio

signal truck_hit_end_point

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("truck"):  # Optional: tag your truck
		winning_audio.play()
		truck_hit_end_point.emit()
