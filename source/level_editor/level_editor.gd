extends Node3D

@onready var PlayerCamera:Node3D = $PlayerCamera
@onready var Grid:StaticBody3D = $Grid
@onready var property_menu:Control = $UI/PropertyMenu
@onready var property_menu_vbox_container:VBoxContainer = $UI/PropertyMenu/VBoxContainer
@onready var no_properties_label:Label = $UI/PropertyMenu/VBoxContainer/NoPropertiesLabel
@onready var level:Node3D = $Level
#@onready var cursor:Node3D = $"3DCursor"

var property_setter_scene:PackedScene = preload("res://source/level_editor/property_setter.tscn")

var selected_objects:Array = []

var selected_scene:PackedScene

var editable_variables:Dictionary = {
	"material" = TYPE_OBJECT,
	"flip_faces" = TYPE_BOOL
}

func _physics_process(_delta: float) -> void:
	Grid.position.x = PlayerCamera.position.x
	Grid.position.z = PlayerCamera.position.z
	
	if Input.is_action_just_pressed("object_menu"):
		%ObjectMenu.visible = !%ObjectMenu.visible


func _on_grid_spin_box_value_changed(value: float) -> void:
	Grid.position.y = value
	%GridSpinBox.get_line_edit().release_focus()


func update_property_menu() -> void:
	for child in property_menu_vbox_container.get_children():
		if child != no_properties_label:
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
