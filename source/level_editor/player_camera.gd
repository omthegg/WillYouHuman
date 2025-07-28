extends Node3D

@onready var Camera:Camera3D = $Camera3D
@onready var RayCast:RayCast3D = $RayCast3D
@onready var cursor:Node3D = get_parent().cursor

var speed:int = 10

var freelook:bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if !Input.is_action_pressed("left_click"):
			if Input.is_action_pressed("right_click"):
				freelook = true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				%GridSpinBox.get_line_edit().release_focus()
		if freelook:
			rotate_y(-event.relative.x * Global.mouse_sens)
			Camera.rotate_x(-event.relative.y * Global.mouse_sens)
			Camera.rotation_degrees.x = clamp(Camera.rotation_degrees.x, -90, 90)
	
	if Input.is_action_just_released("right_click"):
		freelook = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("left_click"):
		if RayCast.is_colliding():
			var collider:CollisionObject3D = RayCast.get_collider()
			if collider.is_in_group("Draggable"):
				collider.start_grab()

func _physics_process(delta: float) -> void:
	if freelook:
		var input_dir_h:Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var input_dir_v:int = int(Input.is_action_pressed("move_up")) - int(Input.is_action_pressed("move_down"))
		var input_dir:Vector3 = Vector3(input_dir_h.x, input_dir_v, input_dir_h.y)
		var direction:Vector3 = (transform.basis * input_dir).normalized()
		position += direction * speed * delta
	
	# Cast ray from mouse
	var m_pos = get_viewport().get_mouse_position()
	var from = Camera.project_ray_origin(m_pos)
	var to = Camera.project_ray_normal(m_pos) * 100
	RayCast.position = from
	RayCast.target_position = to
	
	if RayCast.is_colliding():
		%"3DCursor".position = round(RayCast.get_collision_point())
