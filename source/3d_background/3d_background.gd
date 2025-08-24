extends Node3D

@onready var multi_mesh_instance:MultiMeshInstance3D = $MultiMeshInstance3D

const ROTATION_SPEED:float = 20.0
const MOVEMENT_SPEED:float = 0.5

func _ready():
	for i in multi_mesh_instance.multimesh.instance_count:
		var b:Basis = Basis(Vector3(1.0, 1.0, 1.0).normalized(), randf_range(-90.0, 90.0))
		var o:Vector3 = Vector3(randf_range(-14.5, 14.5), randf_range(-3.5, 3.5), randf_range(-3.0, -10.0))
		var t:Transform3D = Transform3D(b, o)
		multi_mesh_instance.multimesh.set_instance_transform(i, t)


func _physics_process(delta) -> void:
	if !visible:
		return
	
	for i in multi_mesh_instance.multimesh.instance_count:
		var t:Transform3D = multi_mesh_instance.multimesh.get_instance_transform(i)
		t = t.rotated_local(Vector3(1.0, 1.0, 1.0).normalized(), deg_to_rad(ROTATION_SPEED) * delta)
		
		t = t.translated(Vector3(MOVEMENT_SPEED*delta, 0.0, 0.0))
		if t.origin.x >= 14.5:
			t.origin = Vector3(-14.5, randf_range(-3.5, 3.5), randf_range(-3.0, -10.0))
		
		multi_mesh_instance.multimesh.set_instance_transform(i, t)
