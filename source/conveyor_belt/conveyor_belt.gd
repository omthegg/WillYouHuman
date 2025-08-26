extends StaticBody3D

@export var belt_speed:float = 3.0

@onready var start:Node3D = $Start
@onready var end:Node3D = $End
@onready var collision_shape:CollisionShape3D = $CollisionShape3D

@onready var top:MeshInstance3D = $Model/Top
@onready var bottom:MeshInstance3D = $Model/Bottom
@onready var back:MeshInstance3D = $Model/Back
@onready var front:MeshInstance3D = $Model/Front
@onready var left:MeshInstance3D = $Model/Left
@onready var right:MeshInstance3D = $Model/Right
@onready var model:Node3D = $Model

@onready var x_mesh:QuadMesh = left.mesh
@onready var y_mesh:QuadMesh = top.mesh
@onready var z_mesh:QuadMesh = front.mesh

@onready var x_material:StandardMaterial3D = left.material_override
@onready var y_material:StandardMaterial3D = top.material_override
@onready var z_material:StandardMaterial3D = front.material_override

func _ready() -> void:
	x_material.albedo_color = Color.ORANGE_RED
	y_material.albedo_color = Color.ORANGE_RED
	z_material.albedo_color = Color.ORANGE_RED


func _physics_process(_delta) -> void:
	refresh()


func _process(delta) -> void:
	animate(delta)


func refresh() -> void:
	var length:float = start.position.distance_to(end.position)
	x_mesh.size.x = length
	y_mesh.size.y = length
	collision_shape.shape.size.z = length
	
	front.position.z = -length/2
	back.position.z = length/2
	
	var mid_point:Vector3 = (start.position + end.position)/2
	model.position = mid_point
	
	var vector:Vector3 = end.position - start.position
	model.look_at(model.global_position + vector)
	
	collision_shape.position = mid_point
	
	var editor_highlight:MeshInstance3D = get_node_or_null("EditorHighlight")
	if editor_highlight:
		editor_highlight.position = mid_point
		editor_highlight.mesh.size = Vector3(1.0, 0.5, length)
		editor_highlight.rotation = model.rotation


func animate(delta:float) -> void:
	y_material.uv1_offset.y -= belt_speed * delta
	z_material.uv1_offset.y -= belt_speed * delta
