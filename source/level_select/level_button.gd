extends Button

@export var packed_level_scene:PackedScene


func _on_pressed() -> void:
	if !packed_level_scene:
		return
	
	Global.scene_manager.level_select.hide()
	Global.scene_manager.pause_menu.show()
	Global.scene_manager.set_game_paused(false)
	Global.scene_manager.play_level(packed_level_scene)
