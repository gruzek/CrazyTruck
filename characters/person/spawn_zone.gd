extends Node3D

@export var person_scene: PackedScene
@onready var spawn_zone_box: MeshInstance3D = $spawnZoneBox
@export var people_density: float = .1 # people per square meter

func _ready():
	spawn_people()

func spawn_people():
	if person_scene == null:
		print("No person scene assigned.")
		return

	# Get the box size from the BoxMesh
	var box_size = get_box_size()
	var area = box_size.x * box_size.z
	var count = int(area * people_density)

	print("Attempting to spawn ", count, " people")
	for i in count:
		var person = person_scene.instantiate()
		
		var offset = Vector3(
			randf_range(-box_size.x / 2, box_size.x / 2),
			0,
			randf_range(-box_size.z / 2, box_size.z / 2)
		)
		person.global_transform.origin = global_transform.origin + offset
		get_tree().current_scene.add_child(person)
	
func get_box_size() -> Vector3:
	var boxmesh := spawn_zone_box.mesh
	if boxmesh is BoxMesh:
		var mesh_size = boxmesh.size
		var scale = spawn_zone_box.scale
		return mesh_size * scale
	return Vector3(1, 1, 1)  # fallback
