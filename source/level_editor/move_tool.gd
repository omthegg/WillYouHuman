extends Node3D

var size:float = 0.25
var camera:Camera3D

func _ready() -> void:
	camera = get_viewport().get_camera_3d()

#func _process(_delta: float) -> void:
#	var cam_dist:float = camera.global_position.distance_to(global_position)
#	scale = Vector3.ONE * cam_dist * size
