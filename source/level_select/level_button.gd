extends Button

@export var packed_level_scene:PackedScene


func _on_pressed() -> void:
	if !packed_level_scene:
		return
	
	Global.scene_manager.play_level(packed_level_scene)
