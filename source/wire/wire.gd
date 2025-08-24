extends Node3D

@export var powered:bool = false

@export var devices:Array = []:
	set(value):
		update_model()

@onready var mesh_instance:MeshInstance3D = $Model/MeshInstance3D

func update_model() -> void:
	var distance:float = devices[0].global_position.distance_to(devices[1].global_position)
	mesh_instance.mesh.height = distance
	var mid_point:Vector3 = (devices[0].global_position + devices[1].global_position)/2
	global_position = mid_point
	look_at(devices[0].global_position)
