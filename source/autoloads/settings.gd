extends Node

var mouse_sensitivity:float = 0.14

var settings:Dictionary = {
	"vsync" = true,
	"mouse_sensitivity" = 0.14,
	"glow" = true
}

func apply_settings() -> void:
	if settings.get("vsync"):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	mouse_sensitivity = settings.get("mouse_sensitivity")
