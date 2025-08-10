extends CharacterBody3D

@onready var head:Node3D = $Head

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _ready() -> void:
	$MeshInstance3D.mesh.material.albedo_color = Color.GREEN


func _input(event) -> void:
	if (get_parent() is not SubViewport) and (!get_node_or_null("/root/LevelEditor")):
		if event is InputEventMouseMotion:
			head.rotate_x(deg_to_rad(event.relative.y * Global.mouse_sens))
			rotate_y(deg_to_rad(event.relative.x * Global.mouse_sens))


func _physics_process(delta: float) -> void:
	if (get_parent() is not SubViewport) and (!get_node_or_null("/root/LevelEditor")):
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
