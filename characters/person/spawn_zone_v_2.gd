extends MeshInstance3D

@export var person_scene : PackedScene
@export var persons_to_spawn = 3

# Called when the node enters the scene tree for the first time.
func spawn_person() -> void:
	# Get the size of the area
	#var collider = get_node("CollisionShape3D")
	var area_sizes = mesh.size
	print(area_sizes)
	# Get random x & z locations
	var random_x = randf_range(-area_sizes.x / 2.0, area_sizes.x / 2.0)
	var random_z = randf_range(-area_sizes.z / 2.0, area_sizes.z / 2.0)
	var random_position = Vector3(random_x, -area_sizes.y + 2, random_z) # +2 for y to make the characters not spawn through the ground
	
	# Spawn in person
	var new_person = person_scene.instantiate()
	new_person.position = random_position
	add_child(new_person)

func _ready():
	for index in range(persons_to_spawn):
		spawn_person()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#
#func _on_timer_timeout() -> void:
	#spawn_person()
