extends Node2D

func _input(_event):
	if Input.is_action_just_released("console"):
		if !visible:
			$LineEdit.text = ""
			show()
			$LineEdit.grab_focus()
			Global.console_open = true
			get_tree().paused = true
	if Input.is_action_just_pressed("pause"):
		if visible:
			$LineEdit.text = ""
			hide()
			get_tree().paused = false
			Global.console_open = false


func _on_LineEdit_text_entered(new_text:String):
	Global.console_open = false
	get_tree().paused = false
	hide()
	
	if new_text.begins_with("load "):
		var level_name = new_text.replace("load ", "")
		if level_name.ends_with(".map"):
			Global.load_custom_map(level_name)
		else:
			var level_path = str("res://source/maps/", level_name, ".tscn")
			SceneTransition.transition(level_name, level_path)
	
	elif new_text.begins_with("resolution "):
		var resolution_text = new_text.replace("resolution ", "")
		var resolution_array = resolution_text.split(" ")
		if resolution_array.size() == 2:
			Global.change_resolution(Vector2(int(resolution_array[0]), int(resolution_array[1])))
	
	elif new_text.begins_with("LevelEditor") or new_text.begins_with("leveleditor"):
		var _v = get_tree().change_scene("res://source/LevelEditor/LevelEditor.tscn")
	
	elif new_text.begins_with("godmode") or new_text.begins_with("god") or new_text.begins_with("GodMode") or new_text.begins_with("Godmode") or new_text.begins_with("God"):
		Global.god_mode = !Global.god_mode
	
	$LineEdit.text = ""
