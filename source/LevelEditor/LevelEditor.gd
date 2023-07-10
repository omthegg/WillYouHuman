extends Spatial

onready var camera_rotation_helper = $CameraRotationHelper
onready var camera = $CameraRotationHelper/Camera
onready var camera_raycast = $CameraRotationHelper/Camera/RayCast
onready var compass_camera_rotation_helper = $UI/Compass/ViewportContainer/Viewport/CameraRotationHelper
onready var compass_camera = $UI/Compass/ViewportContainer/Viewport/CameraRotationHelper/Camera
onready var cursor = $Cursor
onready var placement_plane = $PlacementPlane
onready var placement_plane_collision_shape = $PlacementPlane/CollisionShape
onready var object_highlight = $ObjectHighlight

onready var templates_grid_container = $UI/TemplatesScrollContainer/TemplatesGridContainer
onready var templates_scrollcontainer = $UI/TemplatesScrollContainer
onready var tsc_vscroll = templates_scrollcontainer.get_v_scrollbar() # TemplatesScrollContainer_VScrollBar
onready var templates_vscrollbar = $UI/TemplatesVScrollBar
onready var materials_grid_container = $UI/MaterialsGridContainer
onready var variables_grid_container = $UI/VariablesGridContainer
onready var groups_grid_container = $UI/GroupsGridContainer
onready var templates_panel = $UI/Panel
onready var materials_panel = $UI/Panel2
onready var variables_panel = $UI/Panel3
onready var groups_panel = $UI/Panel4
onready var group_line_edit = $UI/Panel4/GroupLineEdit
onready var right_click_menu = $UI/RightClickMenu
onready var grid_y_label = $UI/GridYLabel
onready var object_mode_button = $UI/ObjectModeButton
onready var vertex_mode_button = $UI/VertexModeButton
onready var variables_button = $UI/VariablesButton
onready var save_button = $UI/SaveButton
onready var play_button = $UI/PlayButton
onready var save_file_dialog = $UI/SaveFileDialog
onready var load_file_dialog = $UI/LoadFileDialog

onready var map = $Map
onready var map_navmesh = $Map/Navigation/NavigationMeshInstance
onready var map_nav = $Map/Navigation

const NORMAL_CAMERA_SPEED = 15
const FAST_CAMERA_SPEED = 30

var camera_speed = NORMAL_CAMERA_SPEED

var templates = []
var selected_template:LevelEditorTemplate

var materials = []
var selected_material:Material

var selected_object

var snap = 1.0
var rotation_snap = 45

var moved_camera = false

var selected_pivots = []

var surface_drag_first_position:Vector3
var surface_drag_second_position:Vector3
var surface_drag_height:float = 1.0
var surface_drag_instance:StaticBody
var surface_drag_height_mouse_first_y:int
var surface_drag_original_height:float = 1.0

enum EDITOR_MODE {
	OBJECT_MODE = 0,
	VERTEX_MODE = 1,
	VARIABLES = 3
}

var editor_mode = EDITOR_MODE.OBJECT_MODE

var level_scene
var running_level # Not a bool

func _ready():
	print(get("x"))
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	Global.editing_level = true
	Global.level_editor = self
	camera_raycast.set_as_toplevel(true)
	
	$Map/WorldEnvironment.owner = map
	$Map/Navigation.owner = map
	$Map/Navigation/NavigationMeshInstance.owner = map
	
	get_templates()
	add_templates()
	add_materials()
	
	materials_grid_container.get_child(0).pressed = true
	selected_material = materials[0]
	
	$UI/RightClickMenu/DeleteButton.connect("button_up", self, "_on_DeleteButton_button_up")
	
	tsc_vscroll.add_stylebox_override("grabber_highlight", templates_vscrollbar.get_stylebox("grabber_highlight"))
	tsc_vscroll.add_stylebox_override("grabber", templates_vscrollbar.get_stylebox("grabber"))
	tsc_vscroll.add_stylebox_override("scroll", templates_vscrollbar.get_stylebox("scroll"))
	tsc_vscroll.add_stylebox_override("grabber_pressed", templates_vscrollbar.get_stylebox("grabber_pressed"))
	#var polygon3d_instance = Global.polygon3d.instance()
	#map_navmesh.add_child(polygon3d_instance)
	#polygon3d_instance.create_polygon()


func _process(_delta):
	save_file_dialog.rect_global_position = Vector2(0, 0)
	load_file_dialog.rect_global_position = Vector2(0, 0)
	templates_grid_container.rect_position.x = 12
	tsc_vscroll.rect_position.x = 6
	#tsc_vscroll.rect_pivot_offset = Vector2(-12, 0)


func _input(event):
	if event is InputEventMouseMotion:
		if !save_file_dialog.visible:
			if Input.is_action_pressed("charge_shoot"): # Hold right click to control camera
				if Global.editing_level:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and !Global.playing_custom_level:
			camera_rotation_helper.rotate_y(deg2rad(-event.relative.x * (Settings.mouse_sensitivity / 100.0)))
			camera.rotate_x(deg2rad(-event.relative.y * (Settings.mouse_sensitivity / 100.0)))
			camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90))
			compass_camera_rotation_helper.global_rotation = camera.global_rotation
			#moved_camera = true
			right_click_menu.hide()
			#compass_camera.rotation_degrees = camera.rotation_degrees
	
	if Input.is_action_just_released("charge_shoot"):
		if Global.editing_level:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	if Input.is_action_just_pressed("shoot"):
		if !is_mouse_on_ui() and !save_file_dialog.visible:
			if camera_raycast.is_colliding():
				var collider = camera_raycast.get_collider()
				
				if editor_mode == EDITOR_MODE.VERTEX_MODE:
					if collider.is_in_group("Pivot"):
						var pivot_mesh = collider.get_node("MeshInstance")
						if collider in selected_pivots:
							selected_pivots.erase(collider)
							pivot_mesh.get_surface_material(0).albedo_color = Color.yellow
						else:
							selected_pivots.append(collider)
							pivot_mesh.get_surface_material(0).albedo_color = Color.green
				
				if editor_mode == EDITOR_MODE.OBJECT_MODE:
					if Input.is_action_pressed("control"): # Select object if space is being held
						if !collider.is_in_group("Pivot") and collider != placement_plane:
							selected_object = collider
							var collider_collision_shape:CollisionShape = collider.get_node_or_null("CollisionShape")
							if collider_collision_shape:
								#object_highlight.mesh = collider_collision_shape.shape.get_debug_mesh()
								object_highlight.mesh = collider.get_node("MeshInstance").mesh
								object_highlight.global_transform.origin = collider.get_node("MeshInstance").global_transform.origin
								object_highlight.global_rotation = collider.get_node("MeshInstance").global_rotation
								object_highlight.show()
							
							# Disable the vertexmode button if the selected object isn't an editable polygon
							vertex_mode_button.disabled = !selected_object.is_in_group("Polygon3D")
							
							#if selected_object_has_editable_variables():
							# Don't enable the settings tab if the
							# selected object is an EntitySpawner.
							if !("EntitySpawner" in selected_object.name):
								variables_button.disabled = false
						
						if collider == placement_plane:
							if editor_mode == EDITOR_MODE.OBJECT_MODE:
								selected_object = null
								object_highlight.hide()
								variables_button.disabled = true
					
					else:
						if selected_template:
							if selected_template.name != "Surface" and selected_template.name != "PlayerMover":
								place_object()
			
			else:
				if editor_mode == EDITOR_MODE.OBJECT_MODE:
					selected_object = null
					object_highlight.hide()
					variables_button.disabled = true
	
	
	if Input.is_action_just_pressed("shift"): # Speed
		camera_speed = FAST_CAMERA_SPEED
	if Input.is_action_just_released("shift"):
		camera_speed = NORMAL_CAMERA_SPEED
	
	
	if Input.is_action_pressed("g"):
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_WHEEL_UP:
					placement_plane.global_transform.origin.y += snap
				if event.button_index == BUTTON_WHEEL_DOWN:
					placement_plane.global_transform.origin.y -= snap
				
				grid_y_label.text = str("Grid Y: ", placement_plane.global_transform.origin.y)
	
	if Input.is_action_just_pressed("delete"):
		if selected_object and editor_mode == EDITOR_MODE.OBJECT_MODE:
			selected_object.queue_free()
			object_highlight.hide()
			variables_button.disabled = true
	
	
	if Input.is_action_just_pressed("control"):
		cursor.get_node("MeshInstance").hide()
		placement_plane_collision_shape.disabled = true
		#camera_raycast.set_collision_mask_bit(7, false)
	if Input.is_action_just_released("control"):
		cursor.get_node("MeshInstance").show()
		placement_plane_collision_shape.disabled = false
		#camera_raycast.set_collision_mask_bit(7, true)
	
	
	# Rotating
	#if Input.is_action_pressed("r"):
	#	if selected_object:
	#		if !selected_object.is_in_group("Polygon3D"):
	#			if event is InputEventMouseButton:
	#				if event.is_pressed():
	#					if event.button_index == BUTTON_WHEEL_UP:
	#						selected_object.global_rotation.y += deg2rad(rotation_snap)
	#					if event.button_index == BUTTON_WHEEL_DOWN:
	#						selected_object.global_rotation.y -= deg2rad(rotation_snap)
	#					
	#					object_highlight.global_rotation = selected_object.global_rotation


func _physics_process(delta):
	if Global.editing_level:
		move_camera(delta)
		move_pivots()
		move_selected_object()
		rotate_selected_object()
		camera_raycast.global_transform.origin = camera_rotation_helper.global_transform.origin
		
		if is_instance_valid(selected_object):
			object_highlight.scale = selected_object.scale + Vector3(0.1, 0.1, 0.1)
			object_highlight.global_transform.origin = selected_object.get_node("MeshInstance").global_transform.origin
			object_highlight.global_rotation = selected_object.get_node("MeshInstance").global_rotation
		
		var to = camera.project_ray_normal(get_viewport().get_mouse_position())
		camera_raycast.cast_to = to * 500
		if camera_raycast.is_colliding():
			cursor.global_transform.origin = camera_raycast.get_collision_point()
			cursor.global_transform.origin.x = stepify(cursor.global_transform.origin.x, snap)
			cursor.global_transform.origin.y = stepify(cursor.global_transform.origin.y, snap)
			cursor.global_transform.origin.z = stepify(cursor.global_transform.origin.z, snap)
		
		if selected_template:
			if selected_template.name == "Surface" or selected_template.name == "PlayerMover":
				if !is_mouse_on_ui() and !save_file_dialog.visible:
					if (editor_mode == EDITOR_MODE.OBJECT_MODE) and (Input.is_action_just_pressed("shoot")):
						if !Input.is_action_pressed("control"):
							#surface_drag_height = 1.0
							surface_drag_first_position = cursor.global_transform.origin
							surface_drag_instance = place_object()
							surface_drag_instance.get_node("CollisionShape").disabled = true
							
							if surface_drag_first_position.y != placement_plane.global_transform.origin.y:
								placement_plane.global_transform.origin.y = surface_drag_first_position.y
					
					if Input.is_action_pressed("shoot"):
						if surface_drag_instance:
							if !Input.is_action_pressed("alt"):
								surface_drag_second_position = cursor.global_transform.origin
							#if surface_drag_first_position.x > surface_drag_second_position.x:
							#	if surface_drag_first_position.z > surface_drag_second_position.z:
							#		surface_drag_instance.point1 = surface_drag_instance.to_local(surface_drag_first_position)
							#surface_drag_instance.point1 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
							#surface_drag_instance.point2 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
							#surface_drag_instance.point3 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_first_position.z))
							#surface_drag_instance.point4 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_second_position.z))
							#surface_drag_instance.point5 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
							#surface_drag_instance.point6 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
							#surface_drag_instance.point7 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_first_position.z))
							#surface_drag_instance.point8 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_second_position.z))
							
							if (surface_drag_first_position.x < surface_drag_second_position.x) and (surface_drag_first_position.z > surface_drag_second_position.z):
								surface_drag_instance.point5 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
								surface_drag_instance.point6 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
								surface_drag_instance.point7 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_first_position.z))
								surface_drag_instance.point8 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_second_position.z))
								surface_drag_instance.point1 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
								surface_drag_instance.point2 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
								surface_drag_instance.point3 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_first_position.z))
								surface_drag_instance.point4 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_second_position.z))
								#surface_drag_instance.mesh_instance.mesh.flip_faces = true
							elif (surface_drag_first_position.x > surface_drag_second_position.x) and (surface_drag_first_position.z < surface_drag_second_position.z):
								surface_drag_instance.point2 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
								surface_drag_instance.point1 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
								surface_drag_instance.point4 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_first_position.z))
								surface_drag_instance.point3 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_second_position.z))
								surface_drag_instance.point6 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
								surface_drag_instance.point5 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
								surface_drag_instance.point8 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_first_position.z))
								surface_drag_instance.point7 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_second_position.z))
								#surface_drag_instance.mesh_instance.mesh.flip_faces = true
							else:
								#surface_drag_instance.mesh_instance.mesh.flip_faces = falsesurface_drag_instance.point1 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
								surface_drag_instance.point1 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
								surface_drag_instance.point2 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
								surface_drag_instance.point3 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_first_position.z))
								surface_drag_instance.point4 = surface_drag_instance.to_local(Vector3(surface_drag_first_position.x, surface_drag_first_position.y, surface_drag_second_position.z))
								surface_drag_instance.point5 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_first_position.z))
								surface_drag_instance.point6 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y + surface_drag_height, surface_drag_second_position.z))
								surface_drag_instance.point7 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_first_position.z))
								surface_drag_instance.point8 = surface_drag_instance.to_local(Vector3(surface_drag_second_position.x, surface_drag_second_position.y, surface_drag_second_position.z))
							
							surface_drag_instance.align_pivots()
							#surface_drag_instance.rebuild_mesh()
							#surface_drag_instance.refresh_collision_shape()
				
				
				if Input.is_action_just_released("shoot"):
					if surface_drag_instance:
						if is_instance_valid(surface_drag_instance):
							surface_drag_instance.get_node("CollisionShape").disabled = false
							surface_drag_height = 1.0
							surface_drag_original_height = 1.0
							
							if surface_drag_first_position == surface_drag_second_position:
								surface_drag_instance.queue_free()
							
							surface_drag_instance = null
				
				
				if Input.is_action_just_pressed("alt"):
					surface_drag_height_mouse_first_y = get_viewport().get_mouse_position().y
				
				if Input.is_action_pressed("alt"):
					#surface_drag_height = surface_drag_original_height + stepify(surface_drag_height_mouse_first_y/camera.global_transform.origin.distance_to(surface_drag_second_position+Vector3(0, surface_drag_height, 0)), 0.5) - stepify(get_viewport().get_mouse_position().y/camera.global_transform.origin.distance_to(surface_drag_second_position+Vector3(0, surface_drag_height, 0)), 0.5)
					var d = stepify(((surface_drag_height_mouse_first_y - get_viewport().get_mouse_position().y) / 30), 0.5)
					#stepify((surface_drag_height_mouse_first_y - get_viewport().get_mouse_position().y) / sqrt(camera.global_transform.origin.distance_to(surface_drag_second_position+Vector3(0, surface_drag_height, 0))), 0.5)
					if surface_drag_original_height + d > 1.0:
						surface_drag_height = surface_drag_original_height + d
					
					#var mouse_pos = get_viewport().get_mouse_position()
					#if mouse_pos.y < 20:
					#	Input.warp_mouse_position(Vector2(mouse_pos.x, 575))
					#	#surface_drag_original_height -= 600
					#if mouse_pos.y > 580:
					#	surface_drag_height_mouse_first_y -= 580
					#	Input.warp_mouse_position(Vector2(mouse_pos.x, 25))
					#if mouse_pos.x > 1004:
					#	Input.warp_mouse_position(Vector2(25, mouse_pos.y))
					#if mouse_pos.x < 20:
					#	Input.warp_mouse_position(Vector2(999, mouse_pos.y))
				
				#else:
				#	surface_drag_height = 1.0
				
				if Input.is_action_just_released("alt"):
					surface_drag_original_height = surface_drag_height
					if !Input.is_action_pressed("shoot"):
						surface_drag_height = 1.0
						surface_drag_original_height = 1.0


func move_camera(delta):
	if Input.is_action_pressed("charge_shoot"):
		if Input.is_action_pressed("move_forward"):
			camera_rotation_helper.global_transform.origin += -camera.global_transform.basis.z * camera_speed * delta
		if Input.is_action_pressed("move_backward"):
			camera_rotation_helper.global_transform.origin += camera.global_transform.basis.z * camera_speed * delta
		if Input.is_action_pressed("move_left"):
			camera_rotation_helper.global_transform.origin += -camera.global_transform.basis.x * camera_speed * delta
		if Input.is_action_pressed("move_right"):
			camera_rotation_helper.global_transform.origin += camera.global_transform.basis.x * camera_speed * delta
		if Input.is_action_pressed("move_up"):
			camera_rotation_helper.global_transform.origin += camera.global_transform.basis.y * camera_speed * delta
		if Input.is_action_pressed("move_down"):
			camera_rotation_helper.global_transform.origin += -camera.global_transform.basis.y * camera_speed * delta


func get_templates():
	var dir = Directory.new()
	dir.open("res://source/LevelEditor/Templates/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.begins_with("."):
			templates.append(load(str("res://source/LevelEditor/Templates/", file)))
	
	dir.list_dir_end()


func add_templates():
	for template in templates:
		var template_button_instance = TemplateButton.new()
		templates_grid_container.add_child(template_button_instance) # templates_grid_container
		template_button_instance.template = template


# I had to give up on consistancy
func add_materials():
	var dir = Directory.new()
	dir.open("res://textures/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.begins_with(".") and file.ends_with(".tres"):
			var m = load(str("res://textures/", file))
			materials.append(m)
			var material_button_instance = MaterialButton.new()
			materials_grid_container.add_child(material_button_instance)
			material_button_instance.template_material = m
			material_button_instance.name = file.replace(".tres", "")
			print(material_button_instance.name)
			material_button_instance.add_children()
	
	dir.list_dir_end()


func show_selected_object_variables():
	var object_template
	for template in templates:
		#print(template.name)
		if selected_object.name.begins_with(template.name):
			object_template = template
			#print(template.name)
	
	for editable_variable in object_template.editable_variables:
		var variable_editor_instance = VariableEditor.new()
		variables_grid_container.add_child(variable_editor_instance, true)
		variable_editor_instance.variable_name = editable_variable
	
	if selected_object.has_method("show_previews"):
		selected_object.show_previews()


func selected_object_has_editable_variables():
	for template in templates:
		#print(template.name)
		if selected_object.name.begins_with(template.name):
			return true


func hide_selected_object_variables():
	for child in variables_grid_container.get_children():
		child.queue_free()

	if selected_object.has_method("hide_previews"):
		selected_object.hide_previews()


func show_selected_object_groups():
	for group in selected_object.get_groups():
		var group_instance = Group.new()
		groups_grid_container.add_child(group_instance)
		group_instance.group_name = group


func hide_selected_object_groups():
	for child in groups_grid_container.get_children():
		child.queue_free()


func _on_DeleteButton_button_up():
	selected_object.queue_free()
	right_click_menu.hide()


func play_level():
	#map_navmesh.bake_navigation_mesh()
	#yield(map_navmesh, "bake_finished")
	#map.spawn_entities()
	map.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	hide()
	$UI.hide()
	camera.current = false
	placement_plane.get_node("CollisionShape").disabled = true
	object_highlight.hide()
	selected_object = null
	
	Global.editing_level = false
	Global.playing_custom_level = true
	
	var map_instance = level_scene.instance()
	get_tree().get_root().add_child(map_instance, true)
	running_level = map_instance
	pause_mode = Node.PAUSE_MODE_STOP


func reset():
	running_level.queue_free()
	
	yield(running_level, "tree_exited")
	#yield(get_tree(), "idle_frame")
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	show()
	$UI.show()
	placement_plane.get_node("CollisionShape").disabled = false
	
	Global.editing_level = true
	Global.playing_custom_level = false
	
	#var existing_world_environment = find_node("WorldEnvironment")
	
	#if existing_world_environment:
	#	existing_world_environment.queue_free()
	
	var map_instance = level_scene.instance()
	add_child(map_instance, true)
	
	yield(get_tree(), "idle_frame")
	
	map = $Map
	map_navmesh = $Map/Navigation/NavigationMeshInstance
	map_nav = $Map/Navigation
	
	camera.current = true
	#print(map.get_node_or_null("WorldEnvironment").environment.background_sky)


func move_pivots():
	var edited_objects = []
	if editor_mode == EDITOR_MODE.VERTEX_MODE:
		for pivot in selected_pivots:
			if !Input.is_action_pressed("charge_shoot"):
				if Input.is_action_just_pressed("move_forward"):
					pivot.translation.z -= snap
				if Input.is_action_just_pressed("move_backward"):
					pivot.translation.z += snap
				if Input.is_action_just_pressed("move_left"):
					pivot.translation.x -= snap
				if Input.is_action_just_pressed("move_right"):
					pivot.translation.x += snap
				if Input.is_action_just_pressed("move_up"):
					pivot.translation.y += snap
				if Input.is_action_just_pressed("move_down"):
					pivot.translation.y -= snap
				
				if (Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward")
				or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or
				Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down")):
					if !(pivot.get_parent() in edited_objects):
						edited_objects.append(pivot.get_parent())
	
	
	for edited_object in edited_objects:
		if edited_object.is_in_group("Polygon3D"):
			edited_object.rebuild_mesh()
			edited_object.refresh_collision_shape()
			#object_highlight.mesh = edited_object.get_node("CollisionShape").shape.get_debug_mesh()
			object_highlight.mesh = edited_object.get_node("MeshInstance").mesh
			
			play_button.disabled = true


func unpress_template_buttons():
	for button in templates_grid_container.get_children():
		button.pressed = false


func unpress_material_buttons():
	for button in materials_grid_container.get_children():
		button.pressed = false


func show_all_pivots():
	var polygons = get_tree().get_nodes_in_group("Polygon3D")
	for polygon in polygons:
		polygon.show_pivots()

func hide_all_pivots():
	var polygons = get_tree().get_nodes_in_group("Polygon3D")
	for polygon in polygons:
		polygon.hide_pivots()

func show_selected_object_pivots():
	if selected_object:
		if selected_object.is_in_group("Polygon3D"):
			selected_object.show_pivots()
			selected_pivots = []

func hide_selected_object_pivots():
	if selected_object:
		if selected_object.is_in_group("Polygon3D"):
			selected_object.hide_pivots()
			selected_pivots = []


func is_mouse_on_ui():
	var editor_buttons = get_tree().get_nodes_in_group("EditorButton")
	for editor_button in editor_buttons:
		if editor_button.is_hovered() and editor_button.visible:
			return true
	
	var editor_panels = get_tree().get_nodes_in_group("EditorPanel")
	for ep in editor_panels:
		var m = get_viewport().get_mouse_position()
		var ep_pos = ep.rect_position
		var ep_dim = ep.rect_size
		if m.x > ep_pos.x and m.x < ep_pos.x + ep_dim.x and m.y > ep_pos.y and m.y < ep_pos.y + ep_dim.y:
			if ep.visible:
				return true


func _on_ObjectModeButton_pressed():
	vertex_mode_button.pressed = false
	object_mode_button.pressed = true
	variables_button.pressed = false
	
	editor_mode = EDITOR_MODE.OBJECT_MODE
	hide_selected_object_pivots()
	cursor.show()
	templates_grid_container.show()
	templates_panel.show()
	materials_grid_container.show()
	materials_panel.show()
	
	variables_grid_container.hide()
	variables_panel.hide()
	groups_grid_container.hide()
	groups_panel.hide()
	
	placement_plane_collision_shape.disabled = false
	#camera_raycast.set_collision_mask_bit(7, true)
	hide_selected_object_variables()
	hide_selected_object_groups()


func _on_VertexModeButton_pressed():
	vertex_mode_button.pressed = true
	object_mode_button.pressed = false
	variables_button.pressed = false
	
	editor_mode = EDITOR_MODE.VERTEX_MODE
	show_selected_object_pivots()
	cursor.hide()
	templates_grid_container.hide()
	templates_panel.hide()
	materials_grid_container.hide()
	materials_panel.hide()
	
	variables_grid_container.hide()
	variables_panel.hide()
	groups_grid_container.hide()
	groups_panel.hide()
	
	placement_plane_collision_shape.disabled = true
	#camera_raycast.set_collision_mask_bit(7, false)
	hide_selected_object_variables()
	hide_selected_object_groups()


func place_object():
	if selected_template:
		if selected_template.spawn_using_entity_spawner:
			var entity_spawner_instance = Global.entity_spawner.instance()
			map_nav.add_child(entity_spawner_instance)
			entity_spawner_instance.global_transform.origin = cursor.global_transform.origin
			entity_spawner_instance.entity_name = selected_template.name
			entity_spawner_instance.color = selected_template.entity_spawner_color
			entity_spawner_instance.scene = selected_template.scene
			entity_spawner_instance.offset = selected_template.entity_spawner_offset
			entity_spawner_instance.owner = map
			
			entity_spawner_instance.name = selected_template.name
			entity_spawner_instance.name = entity_spawner_instance.name.replace("@", "")
			
			play_button.disabled = true
		else:
			var object_instance = selected_template.scene.instance()
			map_navmesh.add_child(object_instance, true)
			object_instance.global_transform.origin = cursor.global_transform.origin
			if object_instance.is_in_group("Polygon3D"):
				object_instance.create_polygon()
				#object_instance.get_node("MeshInstance").material_override = selected_material
				object_instance.material = selected_material.duplicate()
				#object_instance.uv_scale = selected_material.uv1_scale
				#object_instance.uv_offset = selected_material.uv1_offset
				
				# Renaming the Polygon3D to "Surface" (template name)
				#object_instance.name = "Surface"
				
				# Fixing the name. Only the first surface object
				# will be called "Surface". The other ones will
				# be called "@Surface123", "@Surface124" etc.
				# Why are we changing the name?
				# Because we find the template based on
				# the object's name.
				#if !object_instance.name.begins_with("Surface"):
				#	object_instance.name = object_instance.name.replace("@", "")
				
			object_instance.owner = map
			object_instance.name = selected_template.name
			object_instance.name = object_instance.name.replace("@", "")
			
			play_button.disabled = true
			
			return object_instance


func move_selected_object():
	if editor_mode == EDITOR_MODE.OBJECT_MODE:
		if !Input.is_action_pressed("charge_shoot") and !Input.is_action_pressed("rotate"):
			if selected_object and is_instance_valid(selected_object):
				if Input.is_action_just_pressed("move_forward"):
					selected_object.translation.z -= snap
				if Input.is_action_just_pressed("move_backward"):
					selected_object.translation.z += snap
				if Input.is_action_just_pressed("move_left"):
					selected_object.translation.x -= snap
				if Input.is_action_just_pressed("move_right"):
					selected_object.translation.x += snap
				if Input.is_action_just_pressed("move_up"):
					selected_object.translation.y += snap
				if Input.is_action_just_pressed("move_down"):
					selected_object.translation.y -= snap
				
				if (Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward")
				or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or
				Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down")):
					object_highlight.global_transform.origin = selected_object.global_transform.origin
					play_button.disabled = true


func rotate_selected_object():
	if editor_mode == EDITOR_MODE.OBJECT_MODE:
		if !Input.is_action_pressed("charge_shoot") and Input.is_action_pressed("rotate"):
			if selected_object:
				var object_template
				for template in templates:
					#print(template.name)
					if selected_object.name.begins_with(template.name):
						object_template = template
				
				if !object_template.y_rotation_only:
					if Input.is_action_just_pressed("move_forward"):
						selected_object.rotation_degrees.x -= object_template.rotation_step
					if Input.is_action_just_pressed("move_backward"):
						selected_object.rotation_degrees.x += object_template.rotation_step
					if Input.is_action_just_pressed("move_up"):
						selected_object.rotation_degrees.z -= object_template.rotation_step
					if Input.is_action_just_pressed("move_down"):
						selected_object.rotation_degrees.z += object_template.rotation_step
				
				if Input.is_action_just_pressed("move_left"):
					selected_object.rotation_degrees.y += object_template.rotation_step
				if Input.is_action_just_pressed("move_right"):
					selected_object.rotation_degrees.y -= object_template.rotation_step
				
				
				if (Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward")
				or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or
				Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down")):
					object_highlight.rotation_degrees = selected_object.rotation_degrees
					play_button.disabled = true


#func get_all_children(node:Node):
#	var children = []
#
#	for child in node.get_children():
#		children.append(child)
#		if child.get_child_count() > 0:
#			for i in get_all_children(child):
#				children.append(i)
#
#	return children

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr


func save_level(path):
	map_navmesh.bake_navigation_mesh()
	yield(map_navmesh, "bake_finished")
	
	#for i in get_all_children(map):
	#	i.owner = map
	#	#print(i.owner)
	#	if i is CollisionShape:
	#		print(i.owner)
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(map)
	ResourceSaver.save(path, packed_scene)
	
	level_scene = packed_scene
	if level_scene:
		play_button.disabled = false


func load_level(path):
	selected_object = null
	
	map.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	level_scene = load(path)
	
	var map_instance = level_scene.instance()
	add_child(map_instance, true)
	
	yield(get_tree(), "idle_frame")
	
	map = $Map
	map_navmesh = $Map/Navigation/NavigationMeshInstance
	map_nav = $Map/Navigation
	
	play_button.disabled = false
	variables_button.disabled = true
	vertex_mode_button.disabled = true


func _on_SaveButton_pressed():
	save_file_dialog.popup(Rect2(Vector2(0, 0), Vector2(1024, 600)))


func _on_PlayButton_pressed():
	play_level()


func _on_SaveFileDialog_file_selected(path):
	save_level(path)


func _on_LoadButton_pressed():
	load_file_dialog.popup()


func _on_LoadFileDialog_file_selected(path):
	load_level(path)


func _on_VariablesButton_pressed():
	vertex_mode_button.pressed = false
	object_mode_button.pressed = false
	variables_button.pressed = true
	
	editor_mode = EDITOR_MODE.VARIABLES
	hide_selected_object_pivots()
	cursor.hide()
	templates_grid_container.hide()
	templates_panel.hide()
	materials_grid_container.hide()
	materials_panel.hide()
	
	variables_grid_container.show()
	variables_panel.show()
	groups_grid_container.show()
	groups_panel.show()
	
	placement_plane_collision_shape.disabled = false
	
	show_selected_object_variables()
	show_selected_object_groups()


func _on_GroupLineEdit_text_entered(new_text):
	selected_object.add_to_group(new_text, true)
	hide_selected_object_groups()
	show_selected_object_groups()
	group_line_edit.text = ""


func _on_AddGroupButton_pressed():
	selected_object.add_to_group(group_line_edit.text, true)
	hide_selected_object_groups()
	show_selected_object_groups()
	group_line_edit.text = ""

