extends Node3D

@onready var multi_mesh_instance:MultiMeshInstance3D = $MultiMeshInstance3D

const ROTATION_SPEED:float = 20.0

func _ready():
	for i in multi_mesh_instance.multimesh.instance_count:
		var b:Basis = Basis(Vector3(1.0, 1.0, 1.0).normalized(), randf_range(-90.0, 90.0))
		var o:Vector3 = Vector3(randf_range(-8.0, 8.0), randf_range(-3.5, 3.5), randf_range(-3.0, -10.0))
		var t:Transform3D = Transform3D(b, o)
		multi_mesh_instance.multimesh.set_instance_transform(i, t)

func _physics_process(delta) -> void:
	if !visible:
		return
	
	for i in multi_mesh_instance.multimesh.instance_count:
		var t:Transform3D = multi_mesh_instance.multimesh.get_instance_transform(i)
		t = t.rotated_local(Vector3(1.0, 1.0, 1.0).normalized(), deg_to_rad(ROTATION_SPEED) * delta)
		multi_mesh_instance.multimesh.set_instance_transform(i, t)
