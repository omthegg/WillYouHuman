extends Node

var mouse_sens:float = 0.14

var move_tool:PackedScene = preload("res://source/level_editor/move_tool.tscn")

var display_material:StandardMaterial3D = preload("res://source/materials/display.tres")
var highlight_material:StandardMaterial3D = preload("res://source/materials/editor_highlight.tres")

var scene_manager:Node3D

func _ready() -> void:
	highlight_material.albedo_color = Color.DEEP_SKY_BLUE
	highlight_material.albedo_color.a = 0.2


func generate_random_texture(size:int = 1024) -> Texture2D:
	var rects:Array[Rect2i] = []
	# Add a starting rect that covers the whole image
	rects.append(Rect2i(Vector2i(0, 0), Vector2i(size, size)))
	# How many cuts we can do
	var times:int = size/8
	for i in range(times):
		# Choose a rect
		rects.sort_custom(sort_rects)
		var rect:Rect2i = rects[randi_range(0, (rects.size()-1)/2)]#rects[randi_range(0, rects.size()-1)]
		# Should the cut be vertical?
		var vertical:bool = bool(randf_range(0, rect.size.x/rect.size.y))
		
		# Cut rect in half
		var rect1:Rect2i
		var rect2:Rect2i
		
		if vertical:
			rect1.position = rect.position
			rect1.size = Vector2i(rect.size.x/2, rect.size.y)
			rect2.position = rect.position + Vector2i(rect.size.x/2, 0)
			rect2.size = rect1.size
		else:
			rect1.position = rect.position
			rect1.size = Vector2i(rect.size.x, rect.size.y/2)
			rect2.position = rect.position + Vector2i(0, rect.size.y/2)
			rect2.size = rect1.size
		
		rects.append(rect1)
		rects.append(rect2)
		rects.erase(rect)
	
	var img:Image = Image.create_empty(size, size, false, Image.FORMAT_RGB8)
	img.fill(Color.BLACK)
	for rect in rects:
		img.fill_rect(rect, Color.WHITE)
		var lt:int = 2 # Line thickness
		var rect_s = Rect2i(Vector2i(rect.position.x+lt, rect.position.y+lt), Vector2i(rect.size.x-2*lt, rect.size.y-2*lt))
		img.fill_rect(rect_s, Color.BLACK)
	
	var texture = ImageTexture.create_from_image(img)
	
	return texture


## See sort_custom for arrays
func sort_rects(a:Rect2i, b:Rect2i) -> bool:
	if (a.size.x + a.size.y) > (b.size.x + b.size.y):
		return true
	return false


func create_line_mesh(vertices:PackedVector3Array) -> ArrayMesh:
	var mesh:ArrayMesh = ArrayMesh.new()
	var arrays:Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	return mesh


func add_editor_highlight(node3d:Node3D) -> MeshInstance3D:
	var aabb = get_3d_aabb(node3d)
	var box_mesh:BoxMesh = BoxMesh.new()
	box_mesh.size = aabb.size
	
	var mesh_instance:MeshInstance3D = MeshInstance3D.new()
	node3d.add_child(mesh_instance)
	mesh_instance.mesh = box_mesh
	mesh_instance.global_position = node3d.global_position
	mesh_instance.name = "EditorHighlight"
	mesh_instance.scale *= 1.01
	mesh_instance.material_override = highlight_material
	mesh_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	
	return mesh_instance


func remove_editor_highlight(node3d: Node3D) -> void:
	if is_instance_valid(node3d.get_node_or_null("EditorHighlight")):
		node3d.get_node("EditorHighlight").name = "EditorHighlightDeleted"
		node3d.get_node("EditorHighlightDeleted").queue_free()


func get_3d_aabb(node: Node) -> AABB:
	var scene_aabb:AABB = AABB()
	
	if node is VisualInstance3D:
		scene_aabb = node.get_aabb()
	
	for child in node.get_children():
		if child is VisualInstance3D:
			var child_aabb:AABB = get_3d_aabb(child)
			if child_aabb.size != Vector3.ZERO: # Ignore empty AABBs
				scene_aabb = scene_aabb.merge(child_aabb)
	
	return scene_aabb


func add_gizmos(node3d: Node3D) -> void:
	if node3d.is_in_group("conveyor_belt"):
		var mt1:Node3D = move_tool.instantiate()
		node3d.start.add_child(mt1, true)
		var mt2:Node3D = move_tool.instantiate()
		node3d.end.add_child(mt2, true)
		return
	
	var mt:Node3D = move_tool.instantiate()
	node3d.add_child(mt, true)
	mt.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if node3d.is_in_group("box"):
		node3d.enable_size_tools()
	if node3d is CSGPolygon3D:
		node3d.enable_polygon_tools()


func remove_gizmos(node3d:Node3D) -> void:
	if is_instance_valid(node3d.get_node_or_null("MoveTool")):
		node3d.get_node("MoveTool").name = "MoveToolDeleted"
		node3d.get_node("MoveToolDeleted").queue_free()
	
	if node3d.is_in_group("conveyor_belt"):
		if is_instance_valid(node3d.start.get_node_or_null("MoveTool")):
			node3d.start.get_node("MoveTool").name = "MoveToolDeleted"
			node3d.start.get_node("MoveToolDeleted").queue_free()
		if is_instance_valid(node3d.end.get_node_or_null("MoveTool")):
			node3d.end.get_node("MoveTool").name = "MoveToolDeleted"
			node3d.end.get_node("MoveToolDeleted").queue_free()
	
	if node3d.is_in_group("box"):
		node3d.disable_size_tools()
	if node3d is CSGPolygon3D:
		node3d.disable_polygon_tools()


func is_in_level_editor(node:Node) -> bool:
	if node.get_parent() is SubViewport:
		return true
	
	if !scene_manager.level_editor:
		return false
	if !is_instance_valid(scene_manager.level_editor):
		return false
	
	if node in get_all_children(scene_manager.level_editor):
		return true
	
	return false


func get_all_children(in_node:Node, array:Array = []) -> Array:
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array


func erase_duplicates(array: Array) -> Array:
	var unique: Array = []
	
	for item in array:
		if not unique.has(item):
			unique.append(item)
	
	return unique
