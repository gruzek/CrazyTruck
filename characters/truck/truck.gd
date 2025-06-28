extends RigidBody3D

@export var acceleration := 48.0
@export var max_speed := 60.0
@export var turn_speed := 2.5
@export var friction := 6.0
@onready var front_right_ray: RayCast3D = $FrontRightRay
@onready var back_left_ray: RayCast3D = $BackLeftRay
@onready var back_right_ray: RayCast3D = $BackRightRay
@onready var front_left_ray: RayCast3D = $FrontLeftRay

func _physics_process(delta):
	var velocity := linear_velocity
	var forward := -transform.basis.x  # Your model faces -X
	var drive := 0.0

	# ✅ Apply gravity manually!
	velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	
	# Input: W/S for forward/back
	if Input.is_action_pressed("move_forward"):
		drive += -1.0
	if Input.is_action_pressed("move_backward"):
		drive -= -1.0

	# Movement force
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0  # Ignore vertical motion for driving
	horizontal_velocity = horizontal_velocity.move_toward(
		forward * drive * max_speed,
		acceleration * delta
	)

	# Apply friction when no input
	if drive == 0:
		horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, friction * delta)

	# Steering (only when moving)
	if horizontal_velocity.length() > 0.1:
		var turn := 0.0
		if Input.is_action_pressed("turn_left"):
			turn += 1.0
		if Input.is_action_pressed("turn_right"):
			turn -= 1.0
		rotate_y(turn * turn_speed * delta)


	# Apply new velocity, preserve gravity
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	linear_velocity = velocity
