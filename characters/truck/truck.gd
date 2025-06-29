extends RigidBody3D

@export var acceleration := 48.0
@export var max_speed := 60.0
@export var turn_speed := 2.5
@export var friction := 6.0
@export var first_malfunction_delay_seconds := 15
@export var malfunction_notice_seconds := 5
@export var min_seconds_between_malfunctions := 15
@export var max_seconds_between_malfunctions := 30
@export var min_malfunction_duration_seconds := 5
@export var max_malfunction_duration_seconds := 10

@onready var front_right_ray: RayCast3D = $FrontRightRay
@onready var back_left_ray: RayCast3D = $BackLeftRay
@onready var back_right_ray: RayCast3D = $BackRightRay
@onready var front_left_ray: RayCast3D = $FrontLeftRay


signal game_over_clobbered

signal steering_malfunction
signal brake_malfunction
signal thrust_malfunction
signal nitrous_malfunction

signal steering_malfunction_started
signal brake_malfunction_started
signal thrust_malfunction_started
signal nitrous_malfunction_started

signal operating_normal


var _next_malfunction : String = "none"
var _malfunctions : Array[String] = ["steering_malfunction", "brake_malfunction", "thrust_malfunction", "nitrous_malfunction"]
var _is_notice_generated := false
var _is_malfunction_started := false
var _malfunction_notice_timer : Timer
var _malfunction_start_timer: Timer
var _malfunction_duration_timer: Timer
var _malfunction_sputter_timer: Timer

var _forward := -1.0
var _backward := 1.0
var _turn_left := 1.0
var _turn_right := -1.0

var _is_brake_malfunction := false
var _is_thrust_malfunction := false
var _is_nitrous_malfunction := false

@export var min_sputter_time := 0.05 
@export var max_sputter_time := 0.5

func _initialize_timers() -> void:
	_malfunction_notice_timer = Timer.new()
	_malfunction_notice_timer.autostart = false
	_malfunction_notice_timer.timeout.connect(_process_malfunction_notice)
	_malfunction_notice_timer.one_shot = true
	add_child(_malfunction_notice_timer)
	
	_malfunction_start_timer = Timer.new()
	_malfunction_start_timer.autostart = false
	_malfunction_start_timer.timeout.connect(_process_malfunction)
	_malfunction_start_timer.wait_time = malfunction_notice_seconds
	_malfunction_start_timer.one_shot = true
	add_child(_malfunction_start_timer)
	
	_malfunction_duration_timer = Timer.new()
	_malfunction_duration_timer.autostart = false
	_malfunction_duration_timer.timeout.connect(_malfunction_finished)
	_malfunction_duration_timer.one_shot = true
	add_child(_malfunction_duration_timer)
	
	_malfunction_sputter_timer = Timer.new()
	_malfunction_sputter_timer.autostart = false
	_malfunction_sputter_timer.timeout.connect(_sputter)
	_malfunction_sputter_timer.one_shot = true
	add_child(_malfunction_sputter_timer)

func _ready():
	randomize()
	_initialize_timers()
	_calc_malfunction()
	if not _malfunction_notice_timer.is_inside_tree():
		print("Timer is not in scene tree!")

func _physics_process(delta):
	var velocity := linear_velocity
	var forward := -transform.basis.x  # Your model faces -X
	var drive := 0.0

	# ✅ Apply gravity manually!
	velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	
	# Input: W/S for forward/back
	if Input.is_action_pressed("move_forward"):
		drive += _forward
	if Input.is_action_pressed("move_backward"):
		drive += _backward

	# malfunctions
	if _is_nitrous_malfunction:
		drive += _forward
		
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
			turn += _turn_left
		if Input.is_action_pressed("turn_right"):
			turn += _turn_right
		rotate_y(turn * turn_speed * delta)

	var current_rotation = rotation_degrees

	# Clamp pitch and roll (X and Z), allow yaw (Y) to rotate freely
	current_rotation.x = clamp(current_rotation.x, -10.0, 10.0)
	current_rotation.z = clamp(current_rotation.z, -10.0, 10.0)
	rotation_degrees = current_rotation
	
	# Apply new velocity, preserve gravity
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	linear_velocity = velocity
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("person"):
			print('clobbered')
			emit_signal("game_over_clobbered")

func _malfunction() -> void:
	print("malfunction() _is_notice_generated: ", _is_notice_generated, " _is_malfunction_started: ", _is_malfunction_started)
	if ! _is_notice_generated && ! _is_malfunction_started:
		_process_malfunction_notice()
	if _is_notice_generated && ! _is_malfunction_started:
		_process_malfunction()
	if _is_malfunction_started:
		_malfunction_finished()

func _generate_random_malfunction() -> String:
	var malfunction_index = randi_range(0,_malfunctions.size()-1)
	print("generated malfunction index ",malfunction_index)
	return _malfunctions[malfunction_index]
	
func _calc_malfunction() -> void:
	print("_calc_malfunction()")
	if _next_malfunction == "none": # it's the first malfunction, use the delay
		_next_malfunction = _generate_random_malfunction()
		print("First malfunction is ", _next_malfunction)
		_malfunction_notice_timer.wait_time = first_malfunction_delay_seconds
		_malfunction_notice_timer.start()
		print(_malfunction_notice_timer.is_stopped())
	else:
		_next_malfunction = _generate_random_malfunction()
		var delay = randf_range(min_seconds_between_malfunctions, max_seconds_between_malfunctions)
		_malfunction_notice_timer.wait_time = delay
		_malfunction_notice_timer.start()

func _process_malfunction_notice() -> void:
	print("_process_malfunction_notice() ", _next_malfunction, " notice")
	_is_notice_generated = true
	_malfunction_start_timer.start()
	match _next_malfunction:
		"steering_malfunction":
			steering_malfunction.emit()
		"brake_malfunction":
			brake_malfunction.emit()
		"thrust_malfunction":
			thrust_malfunction.emit()
		"nitrous_malfunction":
			nitrous_malfunction.emit()

func _process_malfunction() -> void:
	print("_process_malfunction() ", _next_malfunction)
	match _next_malfunction:
		"steering_malfunction":
			_switch_left_right()
			steering_malfunction_started.emit()
		"brake_malfunction":
			_is_brake_malfunction = true
			_sputter()
			brake_malfunction_started.emit()
		"thrust_malfunction":
			_is_thrust_malfunction = true
			_sputter()
			thrust_malfunction_started.emit()
		"nitrous_malfunction":
			_is_nitrous_malfunction = true
			nitrous_malfunction_started.emit()
	var malfunction_duration = randf_range(min_malfunction_duration_seconds, max_malfunction_duration_seconds)
	_is_notice_generated = false
	_is_malfunction_started = true
	_malfunction_duration_timer.wait_time = malfunction_duration
	_malfunction_duration_timer.start()

func _sputter() -> void:
	if _is_brake_malfunction:
		_brake_sputter()
	if _is_thrust_malfunction:
		_thrust_sputter()
	var sputter_delay = randf_range(min_sputter_time, max_sputter_time)
	_malfunction_sputter_timer.wait_time = sputter_delay
	_malfunction_sputter_timer.start()

func _brake_sputter() -> void:
	print("_brake_sputter()")
	if ! _is_brake_malfunction:
		return
	if _backward == 1.0:
		_backward = 0
	else:
		_backward = 1.0
	var sputter_delay = randf_range(min_sputter_time, max_sputter_time)

func _thrust_sputter() -> void:
	print("_thrust_sputter()")
	if ! _is_thrust_malfunction:
		return
	if _forward == -1.0:
		_forward = 0
	else:
		_forward = -1.0
	var sputter_delay = randf_range(min_sputter_time, max_sputter_time)
	
func _switch_left_right() -> void:
	print("_switch_left_right()")
	var old_left = _turn_left
	_turn_left = _turn_right
	_turn_right = old_left
	
func _malfunction_finished() -> void:
	print("_malfunction_finished()")
	_is_malfunction_started = false
	match _next_malfunction:
		"steering_malfunction":
			_switch_left_right()
		"brake_malfunction":
			_is_brake_malfunction = false
			_backward = 1.0
		"thrust_malfunction":
			_is_thrust_malfunction = false
			_forward = -1.0
		"nitrous_malfunction":
			_is_nitrous_malfunction = false
	operating_normal.emit()
	_calc_malfunction()
	
