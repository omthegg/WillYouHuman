extends Node3D

@onready var Camera:Camera3D = $Camera3D
@onready var dragging_raycast:RayCast3D = $DraggingRayCast
@onready var selection_raycast:RayCast3D = $SelectionRayCast
@onready var cursor:Node3D = %"3DCursor"
@onready var editor:Node3D = get_parent()

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
		if freelook:
			freelook = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			if selection_raycast.is_colliding():
				var collider:Object = selection_raycast.get_collider()
				if Input.is_action_pressed("control"):
					if collider in editor.selected_objects:
						editor.selected_objects.erase(collider)
						Global.remove_editor_highlight(collider)
						Global.remove_gizmos(collider)
					else:
						editor.selected_objects.append(collider)
						Global.add_editor_highlight(collider)
						Global.add_gizmos(collider)
					
				else:
					for object:Node in editor.selected_objects:
						if object != collider:
							Global.remove_editor_highlight(object)
							Global.remove_gizmos(object)
					
					if !(collider in editor.selected_objects):
						Global.add_editor_highlight(collider)
						Global.add_gizmos(collider)
					
					editor.selected_objects.clear()
					editor.selected_objects.append(collider)
				
				editor.update_property_menu()
	
	
	if Input.is_action_just_pressed("left_click"):
		if dragging_raycast.is_colliding():
			var collider:CollisionObject3D = dragging_raycast.get_collider()
			if collider.is_in_group("Draggable"):
				collider.start_grab()
		
		elif editor.selected_objects.size() == 0:
			place()


func _physics_process(delta: float) -> void:
	if freelook:
		var input_dir_h:Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var input_dir_v:int = int(Input.is_action_pressed("move_up")) - int(Input.is_action_pressed("move_down"))
		var input_dir:Vector3 = Vector3(input_dir_h.x, input_dir_v, input_dir_h.y)
		var direction:Vector3 = (transform.basis * input_dir).normalized()
		position += direction * speed * delta
	
	# Cast rays from mouse
	var m_pos = get_viewport().get_mouse_position()
	var from = Camera.project_ray_origin(m_pos)
	var to = Camera.project_ray_normal(m_pos) * 100
	dragging_raycast.position = from
	dragging_raycast.target_position = to
	selection_raycast.position = from
	selection_raycast.target_position = to
	
	if dragging_raycast.is_colliding():
		cursor.global_position = round(dragging_raycast.get_collision_point())


func place() -> void:
	if editor.selected_scene:
		var object:Object = editor.selected_scene.instantiate()
	
