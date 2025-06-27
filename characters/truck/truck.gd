extends RigidBody3D

@export var acceleration := 15.0
@export var max_speed := 30.0
@export var brake_force := 20.0
@export var turn_speed := 1.5
@export var friction := 8.0

var velocity := Vector3.ZERO

func _physics_process(delta):
	var forward_dir = -transform.basis.z.normalized()  # forward = negative Z
	var right_dir = transform.basis.x.normalized()

	# Acceleration / Brake
	var input_dir = 0.0
	if Input.is_action_pressed("move_forward"):
		input_dir += 1.0
	if Input.is_action_pressed("move_back"):
		input_dir -= 1.0

	# Apply forward force
	if input_dir != 0.0:
		velocity += forward_dir * input_dir * acceleration * delta
	else:
		# Apply friction
		velocity -= velocity * friction * delta

	# Clamp to max speed
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# Apply turning only when moving
	if velocity.length() > 0.1:
		var turn_input := 0.0
		if Input.is_action_pressed("turn_left"):
			turn_input += 1.0
		if Input.is_action_pressed("turn_right"):
			turn_input -= 1.0
		rotate_y(turn_input * turn_speed * delta)

	# Move the truck
	linear_velocity = velocity
