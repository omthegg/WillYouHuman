extends Node3D

var size:float = 0.25
var camera:Camera3D

var previous_global_position:Vector3 = Vector3.ZERO


func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	global_position = get_parent().global_position
	previous_global_position = global_position

func _physics_process(_delta):
	if top_level:
		if global_position != previous_global_position:
			var position_difference:Vector3 = global_position - previous_global_position
			get_parent().global_position += position_difference
			if get_parent() is CSGBox3D:
				get_parent().reset_size_tools()
				get_parent().set_middles()
				get_parent().set_previous_middles()
	
	previous_global_position = global_position
