extends Node3D

@onready var player_camera:Node3D = $PlayerCamera
@onready var Grid:StaticBody3D = $Grid
@onready var property_menu:Control = $UI/PropertyMenu
@onready var property_menu_vbox_container:VBoxContainer = $UI/PropertyMenu/TabContainer/Properties
@onready var no_properties_label:Label = $UI/PropertyMenu/TabContainer/Properties/NoPropertiesLabel
@onready var level:Node3D = $Level
@onready var file_dialog:FileDialog = $UI/FileDialog
@onready var ui:Control = $UI
@onready var dragging_cursor:Node3D = $DraggingCursor
@onready var placement_cursor:Node3D = $PlacementCursor
@onready var networks_text_edit:TextEdit = $UI/NetworksTextEdit
@onready var groups_menu_vbox_container:VBoxContainer = $UI/PropertyMenu/TabContainer/Groups
@onready var group_adding_control:Control = $UI/PropertyMenu/TabContainer/Groups/GroupAdding
@onready var group_line_edit:LineEdit = $UI/PropertyMenu/TabContainer/Groups/GroupAdding/GroupLineEdit

var property_setter_scene:PackedScene = preload("res://source/level_editor/property_setter.tscn")
var group_setter_scene:PackedScene = preload("res://source/group_setter/group_setter.tscn")

var selected_objects:Array = []

var selected_scene:PackedScene

var editable_variables:Dictionary = {
	"material" = TYPE_OBJECT,
	"flip_faces" = TYPE_BOOL,
	"collision" = TYPE_BOOL,
	"depth" = TYPE_FLOAT,
	"rotate_y_90_degrees" = TYPE_BOOL,
	"belt_speed" = TYPE_FLOAT,
	"time" = TYPE_FLOAT,
	"bomb_time" = TYPE_FLOAT,
	"one_time_press" = TYPE_BOOL,
	"weapon" = TYPE_INT,
	"group_to_move" = TYPE_STRING,
	"movement_vector" = TYPE_VECTOR3
	#"global_position" = TYPE_VECTOR3
}

var hidden_groups:Array = [
	"box",
	"player",
	"antenna",
	"conveyor_belt",
	"Draggable",
	"enemy",
	"moved_by_conveyor_belt",
	"no_collision",
	"wire"
]


func _ready() -> void:
	selected_scene = $UI/ObjectMenu/GridContainer.get_child(0).scene
	$UI/ObjectMenu/SelectionOverlay.global_position = $UI/ObjectMenu/GridContainer.get_child(0).global_position


func _physics_process(_delta: float) -> void:
	Grid.position.x = player_camera.position.x
	Grid.position.z = player_camera.position.z
	
	if Input.is_action_just_pressed("object_menu"):
		%ObjectMenu.visible = !%ObjectMenu.visible
	
	if level:
		for network in level.networks:
			level.update_network(network)
		
		level.update_debug_info()
		networks_text_edit.text = str(level.networks).replace(", ", "\n").replace("[", "").replace("]", "")


func _on_grid_spin_box_value_changed(value: float) -> void:
	Grid.position.y = value
	%GridSpinBox.get_line_edit().release_focus()


func update_property_menu() -> void:
	for child in property_menu_vbox_container.get_children():
		if child != no_properties_label:
			child.queue_free()
	
	for child in groups_menu_vbox_container.get_children():
		if child != group_adding_control:
			child.queue_free()
	
	if selected_objects.size() == 0:
		property_menu.hide()
	else:
		property_menu.show()
		if selected_objects_are_same_type():
			add_property_setters()
			if property_menu_vbox_container.get_child_count() == 1:
				no_properties_label.show()
			else:
				no_properties_label.hide()
		
		add_group_setters()


func selected_objects_are_same_type() -> bool:
	for object in selected_objects:
		if object.get_class() != selected_objects[0].get_class():
			return false
	
	return true


func add_property_setters() -> void:
	var variables:PackedStringArray = []
	for k in editable_variables:
		if selected_objects[0].get(k) != null:
			if editable_variables.get(k) == typeof(selected_objects[0].get(k)):
				variables.append(k)
	
	for v in variables:
		var property_setter:Node = property_setter_scene.instantiate()
		property_menu_vbox_container.add_child(property_setter)
		property_setter.variable_name = v


func set_selected_objects_property(property_name:String, value:Variant) -> void:
	for object in selected_objects:
		object.set(property_name, value)


func save_level(path:String) -> void:
	for child in Global.get_all_children(level):
		child.owner = level
	
	var save:PackedScene = PackedScene.new()
	save.pack(level)
	ResourceSaver.save(save, path)


func load_level(path:String) -> void:
	level.queue_free()
	level = load(path).instantiate()
	level.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(level, true)
	selected_objects.clear()
	update_property_menu()


func play_level() -> void:
	player_camera.camera.current = false
	var packed_level:PackedScene = PackedScene.new()
	for child in Global.get_all_children(level):
		child.owner = level
	
	packed_level.pack(level)
	Global.scene_manager.play_level(packed_level, true, true)
	hide()
	ui.hide()
	process_mode = Node.PROCESS_MODE_DISABLED


func deselect_all_objects() -> void:
	for object in selected_objects:
		Global.remove_editor_highlight(object)
		Global.remove_gizmos(object)
	
	selected_objects.clear()
	update_property_menu()


func add_group_setters() -> void:
	var groups_found:PackedStringArray = []
	for selected_object:Node3D in selected_objects:
		for group_name:StringName in selected_object.get_groups():
			if group_name in hidden_groups:
				continue
			
			if group_name.begins_with("_"):
				continue
			
			if group_name in groups_found:
				continue
			
			groups_found.append(str(group_name))
	
	for group_name:String in groups_found:
		var group_setter:Control = group_setter_scene.instantiate()
		group_setter.name = group_name
		groups_menu_vbox_container.add_child(group_setter, true)
		group_setter.group_name = group_name
		group_setter.label.text = group_name


func show_file_dialog() -> void:
	file_dialog.popup(Rect2i(8, 32, 1136, 610))


func _on_save_button_pressed() -> void:
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	show_file_dialog()


func _on_file_dialog_file_selected(path) -> void:
	match file_dialog.file_mode:
		FileDialog.FILE_MODE_SAVE_FILE:
			save_level(path)
		FileDialog.FILE_MODE_OPEN_FILE:
			load_level(path)


func _on_play_button_pressed() -> void:
	play_level() # Look inside the function before you change this line


func _on_load_button_pressed() -> void:
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	show_file_dialog()


func _on_delete_button_pressed() -> void:
	for object:Node in selected_objects:
		object.queue_free()
	
	selected_objects.clear()
	update_property_menu()


func _on_deselect_button_pressed() -> void:
	deselect_all_objects()


func _on_networks_button_pressed():
	networks_text_edit.visible = !networks_text_edit.visible


func _on_add_group_button_pressed():
	if group_line_edit.text == "":
		return
	
	var group_name:String = group_line_edit.text
	group_line_edit.text = ""
	
	var group_setter:Control = group_setter_scene.instantiate()
	group_setter.name = group_name
	groups_menu_vbox_container.add_child(group_setter, true)
	group_setter.group_name = group_name
	group_setter.add_selected_objects_to_group()
