extends Control


func _on_continue_button_pressed():
	Global.scene_manager.set_game_paused(false)


func _on_exit_button_pressed():
	get_tree().quit()
