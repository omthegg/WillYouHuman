extends Node3D

@onready var multi_mesh_instance = $MultiMeshInstance3D

func _ready():
	for i in 10:
		multi_mesh_instance.multimesh
