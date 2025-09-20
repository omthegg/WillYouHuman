extends StaticBody3D

@onready var mesh_instance:MeshInstance3D = $MeshInstance3D
@onready var collision_shape:CollisionShape3D = $CollisionShape3D
@onready var box_gizmo_component:Node3D = $BoxGizmoComponent
@onready var area_collision_shape:CollisionShape3D = $Area3D/CollisionShape3D
@onready var mover_component:Node3D = $MoverComponent


func _physics_process(_delta: float) -> void:
	change_appearance()


func change_appearance() -> void:
	mesh_instance.mesh.size = box_gizmo_component.size
	collision_shape.shape.size = box_gizmo_component.size
	area_collision_shape.shape.size = box_gizmo_component.size


func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body.is_in_group("player"):
		return
	
	mover_component.objects.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if !body.is_in_group("player"):
		return
	
	mover_component.objects.erase(body)
