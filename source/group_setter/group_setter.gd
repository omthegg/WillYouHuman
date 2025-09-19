extends Control

@onready var editor:Node3D = Global.scene_manager.level_editor
@onready var label:Label = $Label

var group_name:String = ""

func _on_delete_button_pressed() -> void:
	for selected_object:Node3D in editor.selected_objects:
		selected_object.remove_from_group(group_name)
		queue_free()


func add_selected_objects_to_group() -> void:
	for selected_object:Node3D in editor.selected_objects:
		selected_object.add_to_group(group_name)
