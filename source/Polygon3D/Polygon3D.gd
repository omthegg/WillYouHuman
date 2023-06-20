extends StaticBody

#export var points:PoolVector3Array = []
export var point1 = Vector3(1, 1, 1) setget set_point1_verts # Right Up Back
export var point2 = Vector3(1, 1, -1) setget set_point2_verts # Right Up Front
export var point3 = Vector3(1, -1, 1) setget set_point3_verts # Right Down Back
export var point4 = Vector3(1, -1, -1) setget set_point4_verts # Right Down Front
export var point5 = Vector3(-1, 1, 1) setget set_point5_verts # Left Up Back
export var point6 = Vector3(-1, 1, -1) setget set_point6_verts # Left Up Front
export var point7 = Vector3(-1, -1, 1) setget set_point7_verts # Left Down Back
export var point8 = Vector3(-1, -1, -1) setget set_point8_verts # Left Down Front

var point1_verts = []
var point2_verts = []
var point3_verts = []
var point4_verts = []
var point5_verts = []
var point6_verts = []
var point7_verts = []
var point8_verts = []

var points = [point1, point2, point3, point4, point5, point6, point7, point8]
var point_verts = [point1_verts, point2_verts, point3_verts, point4_verts, point5_verts, point6_verts, point7_verts, point8_verts]

var cube_mesh = CubeMesh.new()
#var mesh_instance = MeshInstance.new()
onready var mesh_instance = $MeshInstance
#var csg_mesh = CSGMesh.new()
export var mesh:Mesh = ArrayMesh.new()
export var material:SpatialMaterial = SpatialMaterial.new() setget set_material
var mdt = MeshDataTool.new()

var mesh_vertices:PoolVector3Array = []

onready var pivots = [$Point1Pivot, $Point2Pivot, $Point3Pivot, $Point4Pivot, $Point5Pivot, $Point6Pivot, $Point7Pivot, $Point8Pivot]
onready var collision_shape = $CollisionShape

export var triplanar:bool = true setget set_triplanar

# mesh_vertices gets saved
# saving the MeshDataTool seems to be the problem

export var uv_scale:Vector3 setget set_uv_scale
export var uv_offset:Vector3 setget set_uv_offset

func _input(_event):
	if Input.is_action_just_pressed("kill"):
		print(mdt.get_vertex_count())


func _ready():
	#add_child(mesh_instance, true)
	#print(cubemesh.get_mesh_arrays())
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, cube_mesh.get_mesh_arrays())
	mdt.create_from_surface(mesh, 0)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	#mesh_instance.material_override = mesh_instance.material_override.duplicate()
	#uv_scale = mesh_instance.material_override.uv1_scale 
	#uv_offset = mesh_instance.material_override.uv1_offset
	#mesh_instance.material_override.resource_local_to_scene = true
	#refresh_collision_shape()
	#yield(get_tree(), "idle_frame")
	align_pivots()
	hide_pivots()
	
	#if mesh_vertices.size() > 0:
	mesh_vertices = []
	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
		#print(vert)
		mesh_vertices.append(vert)
	
	refresh_collision_shape()
	
	associate_vertices_with_points()
	
	#print(mesh_vertices)
	
	yield(get_tree(), "idle_frame")
	uv_scale = mesh_instance.material_override.uv1_scale 
	uv_offset = mesh_instance.material_override.uv1_offset
	
	#mesh.surface_remove(1)
#	var pivot_mesh = SphereMesh.new()
#	pivot_mesh.radial_segments = 8
#	pivot_mesh.rings = 4
#	pivot_mesh.radius = 0.2
#	pivot_mesh.height = 0.4
#	pivot_mesh.resource_local_to_scene = true
#
#	var pivot_shape = SphereShape.new()
#	pivot_shape.radius = 0.2
#
#	for pivot in pivots:
#		if !pivot.get_node_or_null("MeshInstance"):
#			var mesh_instance = MeshInstance.new()
#			pivot.add_child(mesh_instance, true)
#			mesh_instance.mesh = pivot_mesh
#		if !pivot.get_node_or_null("CollisionShape"):
#			var collision_shape = CollisionShape.new()
#			collision_shape.shape = pivot_shape
#
#	if mesh_instance.mesh and Global.editing_level:
#		pivots = [$Point1Pivot, $Point2Pivot, $Point3Pivot, $Point4Pivot, $Point5Pivot, $Point6Pivot, $Point7Pivot, $Point8Pivot]
#		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_instance.mesh.surface_get_arrays(0))
#		mdt.create_from_surface(mesh, 0)
#		associate_vertices_with_points()
#	if mdt.get_vertex_meta(0):
#		print(mdt.get_vertex_meta(0))
#	for pivot in pivots:
#		pivot.owner = self
#		pivot.get_node("CollisionShape").owner = self


func create_polygon():
	#align_pivots()
	hide_pivots()
	
	#add_child(mesh_instance, true)
	#print(cubemesh.get_mesh_arrays())
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, cube_mesh.get_mesh_arrays())
	mdt.create_from_surface(mesh, 0)
	
	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
		#print(vert)
		mesh_vertices.append(vert)
	
	#print(mesh_vertices)
	
	associate_vertices_with_points()
	
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	mesh_instance.mesh = mesh
	refresh_collision_shape()
	


#func _input(_event):
#	if Input.is_action_just_pressed("jump"):
#		#for i in range(8):
#		#	set_point_vertices(i + 1, Vector3(rand_range(-2, 2), rand_range(-2, 2), rand_range(-2, 2)))
#		set_point_vertices(1, Vector3(3, 0, 0))


func align_pivots():
	$Point1Pivot.translation = point1
	$Point2Pivot.translation = point2
	$Point3Pivot.translation = point3
	$Point4Pivot.translation = point4
	$Point5Pivot.translation = point5
	$Point6Pivot.translation = point6
	$Point7Pivot.translation = point7
	$Point8Pivot.translation = point8


func associate_vertices_with_points():
	for pivot in range(len(pivots)): #points
		for vertex in range(len(mesh_vertices)):
			if mesh_vertices[vertex] == pivots[pivot].translation:# == points[point]:
				#print("vert")
				#var var_name = "point" + str(point+1) + "_verts"
				#print(var_name)
				
				point_verts[pivot].append(vertex)
				#point_verts[point].append(vertex)
				
				#set(var_name, point_vertices)
				#print(get(var_name))


func set_point_vertices(point_number:int, new_point:Vector3):#, old_point:Vector3):
	#var old_verts = get(verts_array_name)
	#for vert in get(verts_array_name):
	#	vert = point
	#var verts_array_name = "point" + str(point_number) + "_verts"
	#print("E")
	if !mesh_instance:
		mesh_instance = $MeshInstance
	
	for vert in point_verts[point_number-1]:#get(verts_array_name):
		mesh_vertices[vert] = new_point
		mdt.set_vertex(vert, new_point)
	
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	mesh_instance.mesh = mesh
	refresh_collision_shape()


func set_point1_verts(value):
	point1 = value
	if len(point1_verts) != null:
		set_point_vertices(1, value)

func set_point2_verts(value):
	point2 = value
	if len(point2_verts) != null:
		set_point_vertices(2, value)

func set_point3_verts(value):
	point3 = value
	if len(point3_verts) != null:
		set_point_vertices(3, value)

func set_point4_verts(value):
	point4 = value
	if len(point4_verts) != null:
		set_point_vertices(4, value)

func set_point5_verts(value):
	point5 = value
	if len(point5_verts) != null:
		set_point_vertices(5, value)

func set_point6_verts(value):
	point6 = value
	if len(point6_verts) != null:
		set_point_vertices(6, value)

func set_point7_verts(value):
	point7 = value
	if len(point7_verts) != null:
		set_point_vertices(7, value)

func set_point8_verts(value):
	point8 = value
	if len(point8_verts) != null:
		set_point_vertices(8, value)


func show_pivots():
	#align_pivots()
	for pivot in pivots:
		pivot.show()
		pivot.get_node("CollisionShape").disabled = false

func hide_pivots():
	for pivot in pivots:
		pivot.hide()
		pivot.get_node("MeshInstance").get_surface_material(0).albedo_color = Color.yellow
		pivot.get_node("CollisionShape").disabled = true


func rebuild_mesh():
	point1 = $Point1Pivot.translation
	point2 = $Point2Pivot.translation
	point3 = $Point3Pivot.translation
	point4 = $Point4Pivot.translation
	point5 = $Point5Pivot.translation
	point6 = $Point6Pivot.translation
	point7 = $Point7Pivot.translation
	point8 = $Point8Pivot.translation
	
	#set("point1", $Point1Pivot.translation)
	
	set_point_vertices(1, $Point1Pivot.translation)
	set_point_vertices(2, $Point2Pivot.translation)
	set_point_vertices(3, $Point3Pivot.translation)
	set_point_vertices(4, $Point4Pivot.translation)
	set_point_vertices(5, $Point5Pivot.translation)
	set_point_vertices(6, $Point6Pivot.translation)
	set_point_vertices(7, $Point7Pivot.translation)
	set_point_vertices(8, $Point8Pivot.translation)


func refresh_collision_shape():
	if collision_shape:
		collision_shape.shape.points = mesh_vertices


func set_material(value):
	if !mesh_instance:
		yield(self, "ready")
	
	material = value
	mesh_instance.material_override = material


func set_uv_scale(value):
	if !mesh_instance:
		yield(self, "ready")
	
	uv_scale = value
	mesh_instance.material_override.uv1_scale = uv_scale


func set_uv_offset(value):
	if !mesh_instance:
		yield(self, "ready")
	
	uv_scale = value
	mesh_instance.material_override.uv1_offset = uv_offset


func set_triplanar(value):
	triplanar = value
	mesh_instance.material_override.flags_world_triplanar = value
	mesh_instance.material_override.uv1_triplanar = value
