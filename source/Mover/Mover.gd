extends StaticBody

export var move_group:String setget set_move_group
export var move_vector:Vector3 = Vector3(0.0, 0.0, 0.0) setget set_move_vector
export var time:float = 1.0

var preview_lines = []
var preview_meshes = []
var preview_highlights = []

func _ready():
	if !Global.editing_level:
		hide()
		$CollisionShape.disabled = true

func trigger():
	var nodes = get_tree().get_nodes_in_group(move_group)
	for node in nodes:
		var tween = create_tween()
		#add_child(tween)
		tween.tween_property(node, "global_transform:origin", node.global_transform.origin + move_vector, time)
		


func show_previews():
	var nodes = get_tree().get_nodes_in_group(move_group)
	for node in nodes:
		var line3d_instance = Line3D.new()
		add_child(line3d_instance)
		line3d_instance.global_transform.origin = Vector3.ZERO
		line3d_instance.line_begin = node.global_transform.origin
		line3d_instance.line_end = node.global_transform.origin + move_vector
		preview_lines.append(line3d_instance)
		
		var node_mesh_instance = node.get_node_or_null("MeshInstance")
		if node_mesh_instance:
			var node_mesh_copy = node_mesh_instance.mesh.duplicate()
			var node_mesh_material_copy:SpatialMaterial = node_mesh_instance.material_override.duplicate()
			node_mesh_material_copy.flags_transparent = true
			node_mesh_material_copy.albedo_color.a = 0.7
			var preview_mesh_instance = MeshInstance.new()
			add_child(preview_mesh_instance)
			preview_mesh_instance.mesh = node_mesh_copy
			preview_mesh_instance.material_override = node_mesh_material_copy
			preview_mesh_instance.global_transform.origin = node.global_transform.origin + move_vector
			preview_meshes.append(preview_mesh_instance)
			
			var highlight_mesh_instance = MeshInstance.new()
			add_child(highlight_mesh_instance)
			highlight_mesh_instance.mesh = node_mesh_instance.mesh
			highlight_mesh_instance.global_transform.origin = node_mesh_instance.global_transform.origin
			highlight_mesh_instance.scale = Vector3(1.001, 1.001, 1.001)
			var m = SpatialMaterial.new()
			m.flags_transparent = true
			m.albedo_color = Color.orangered
			m.albedo_color.a = 0.25
			highlight_mesh_instance.material_override = m
			preview_highlights.append(highlight_mesh_instance)


func hide_previews():
	for preview_line in preview_lines:
		preview_line.queue_free()
	preview_lines = []
	
	for preview_mesh in preview_meshes:
		preview_mesh.queue_free()
	preview_meshes = []
	
	for preview_highlight in preview_highlights:
		preview_highlight.queue_free()
	preview_highlights = []


func set_move_group(value):
	move_group = value
	if get_parent():
		hide_previews()
		show_previews()

func set_move_vector(value):
	move_vector = value
	if get_parent():
		hide_previews()
		show_previews()
