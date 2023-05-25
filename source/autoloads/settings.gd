extends Node

var fov = 90 setget set_fov
var rendering_enabled = false setget set_rendering_enabled
var mouse_sensitivity = 15.0 # devide by 100 to find the value used by the player script
var viewmodel_fov setget set_viewmodel_fov

var skin

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func set_fov(value):
	Global.player.camera.fov = value
	Global.player.thirdperson_camera.fov = value
	fov = value

func set_viewmodel_fov(value):
	Global.player.arms.set_fov(value)
	viewmodel_fov = value

func set_rendering_enabled(enabled):
	if enabled:
		Global.player.camera.current = true
	else:
		if get_viewport().get_camera():
			get_viewport().get_camera().clear_current(false)


func set_viewport_size(new_size:Vector2):
	get_viewport().size = new_size#.set_size_override(true, new_size)
