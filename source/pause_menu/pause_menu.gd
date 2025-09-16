extends Control

@onready var editor_button:Button = $VBoxContainer/EditorButton

func _on_continue_button_pressed() -> void:
	Global.scene_manager.set_game_paused(false)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_editor_button_pressed() -> void:
	Global.scene_manager.return_to_level_editor()


func _on_settings_button_pressed() -> void:
	Global.scene_manager.go_to_settings()


func _on_levels_button_pressed() -> void:
	Global.scene_manager.go_to_level_select()
