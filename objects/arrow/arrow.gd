extends Node3D

@onready var arrow_mesh = $Arrow
var end_point: Node3D = null
@export var max_slide_distance := 3.0  # max offset in Z (side to side)

func _ready():
	# Search the current scene tree for a node named "EndPoint"
	end_point = get_tree().get_current_scene().find_child("EndPoint", true, true)
	if end_point == null:
		push_warning("EndPoint not found in the scene.")
		
func _process(_delta):
	if not end_point:
		return
		
	var arrow_pos = global_transform.origin
	var target_pos = end_point.global_transform.origin
	
	# Flatten both positions to ignore vertical difference (Y-axis)
	arrow_pos.y = 0
	target_pos.y = 0
	
	look_at(target_pos, Vector3.UP)
	rotate_y(deg_to_rad(180))  # Since the mesh faces -X instead of +Z
	
	# Get direction and calculate angle
	#var direction = (target_pos - arrow_pos).normalized()
	#var angle = atan2(-direction.z, direction.x)  # since arrow points -X

	#print(angle)
	
	# Apply rotation only on Y axis
	#rotation.y = angle
