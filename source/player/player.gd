extends CharacterBody3D

@onready var head:Node3D = $Head
@onready var camera:Camera3D = $Head/Camera3D

const SPEED = 10.0
const JUMP_VELOCITY = 6.0

var in_level_editor:bool = false
var extra_jumps:int = 1

var camera_tilt_angle:float = 1.0
var camera_tilt_speed:float = 10.0

var dragged_wire:Node3D


func _input(event) -> void:
	if event is InputEventMouseMotion:
		head.rotate_x(deg_to_rad(-event.relative.y * Global.mouse_sens))
		rotate_y(deg_to_rad(-event.relative.x * Global.mouse_sens))
		head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90.0, 90.0)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		extra_jumps = 1
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif extra_jumps > 0:
			velocity.y = JUMP_VELOCITY
			extra_jumps -= 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
		velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED/2)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, SPEED/2)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/6)
		velocity.z = move_toward(velocity.z, 0, SPEED/6)
	
	tilt_camera(input_dir.x, delta)
	
	move_and_slide()
	
	if !dragged_wire:
		return
	if !is_instance_valid(dragged_wire):
		return
	#dragged_wire.update_model()


func _exit_tree():
	if !dragged_wire:
		return
	if !is_instance_valid(dragged_wire):
		return
	dragged_wire.queue_free()


func tilt_camera(factor:float, delta_time:float) -> void:
	if factor > 0.0:
		camera.rotation.z = lerp_angle(camera.rotation.z
		, deg_to_rad(-camera_tilt_angle), camera_tilt_speed*delta_time)
	if factor < 0.0:
		camera.rotation.z = lerp_angle(camera.rotation.z
		, deg_to_rad(camera_tilt_angle), camera_tilt_speed*delta_time)
	if factor == 0.0:
		camera.rotation.z = lerp_angle(camera.rotation.z
		, deg_to_rad(0), camera_tilt_speed*delta_time)


func die() -> void:
	pass
