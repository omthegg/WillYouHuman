extends Control

@onready var v_box_container:VBoxContainer = $VBoxContainer

var packed_level_button:PackedScene = preload("res://source/level_select/level_button.tscn")

func _ready() -> void:
	add_levels_elements()


func add_levels_elements() -> void:
	var levels_folder:DirAccess = DirAccess.open("res://source/levels/")
	levels_folder.list_dir_begin()
	for chapter_folder_name:String in levels_folder.get_directories():
		var chapter_label:Label = Label.new()
		chapter_label.text = chapter_folder_name.capitalize()
		chapter_label.name = chapter_folder_name
		v_box_container.add_child(chapter_label, true)
		
		var chapter_folder:DirAccess = DirAccess.open("res://source/levels/" + chapter_folder_name)
		chapter_folder.list_dir_begin()
		for level_file_name:String in chapter_folder.get_files():
			var level_button:Button = packed_level_button.instantiate()
			var level_name:String = level_file_name.replace(".tscn", "")
			level_button.name = level_name
			level_button.text = level_name.capitalize().replace(" ", "")
			level_button.packed_level_scene = load("res://source/levels/" + chapter_folder_name + "/" + level_file_name)
			v_box_container.add_child(level_button, true)


func _on_back_button_pressed() -> void:
	hide()
	Global.scene_manager.pause_menu.show()


func _on_level_editor_button_pressed() -> void:
	hide()
	Global.scene_manager.pause_menu.show()
	Global.scene_manager.set_game_paused(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.scene_manager.play_level(Global.scene_manager.packed_level_editor, false, false)
