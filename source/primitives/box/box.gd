extends StaticBody3D

@export var size:Vector3 = Vector3.ONE
@export var collision:bool = true
@export var material:Material = ColorManager.procedural_material
@export var flip_faces:bool = false

@onready var mesh_instance:MeshInstance3D = $MeshInstance3D
@onready var collision_shape:CollisionShape3D = $CollisionShape3D
@onready var box_gizmo_component:Node3D = $BoxGizmoComponent


func change_appearance() -> void:
	mesh_instance.mesh.size = box_gizmo_component.size
	mesh_instance.mesh.flip_faces = flip_faces
	collision_shape.shape.size = box_gizmo_component.size
	collision_shape.disabled = !collision
	mesh_instance.material_override = material
