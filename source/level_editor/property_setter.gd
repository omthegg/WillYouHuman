extends Control

@onready var editor:Node3D = Global.scene_manager.level_editor

@onready var material_list_button:MenuButton = $MaterialListButton
@onready var material_list_button_popup:PopupMenu = material_list_button.get_popup()
@onready var material_option_button:OptionButton = $MaterialOptionButton
@onready var material_option_button_popup:PopupMenu = material_option_button.get_popup()
@onready var label:Label = $Label
@onready var line_edit:LineEdit = $LineEdit
@onready var spinbox:SpinBox = $SpinBox
@onready var checkbox:CheckBox = $CheckBox
@onready var vector3_spinboxes:Control = $Vector3SpinBoxes
@onready var spinbox_x:SpinBox = $Vector3SpinBoxes/SpinBoxX
@onready var spinbox_y:SpinBox = $Vector3SpinBoxes/SpinBoxY
@onready var spinbox_z:SpinBox = $Vector3SpinBoxes/SpinBoxZ

var variable_name:String = "":
	set(value):
		variable_name = value
		var type:int = editor.editable_variables.get(variable_name)
		label.text = variable_name.capitalize()
		label.show()
		match type:
			TYPE_OBJECT:
				#material_list_button.show()
				var material_name:String = editor.selected_objects[0].get(variable_name).resource_name
				var id:int = 0
				for i in material_list_button_popup.item_count:
					if material_list_button_popup.get_item_text(i) == material_name:
						id = material_list_button_popup.get_item_id(i)
				
				material_list_button_popup.set_item_checked(id, true)
				#material_button.text = "Material: " + 
				
				material_option_button.show()
				var index:int = 0
				for i in material_option_button_popup.item_count:
					if material_option_button_popup.get_item_text(i) == material_name:
						id = material_option_button_popup.get_item_id(i)
				
				material_option_button.select(index)
			
			TYPE_BOOL:
				label.hide()
				checkbox.text = variable_name.capitalize()
				checkbox.show()
				checkbox.button_pressed = editor.selected_objects[0].get(variable_name)
			
			TYPE_FLOAT:
				spinbox.show()
				spinbox.value = editor.selected_objects[0].get(variable_name)
				spinbox.step = 0.01
			
			TYPE_VECTOR3:
				vector3_spinboxes.show()
				variable_vector3 = editor.selected_objects[0].get(variable_name)
				spinbox_x.value = variable_vector3.x
				spinbox_y.value = variable_vector3.y
				spinbox_z.value = variable_vector3.z
			
			TYPE_STRING:
				line_edit.show()
				line_edit.text = editor.selected_objects[0].get(variable_name)


var variable_vector3:Vector3 = Vector3.ZERO


var materials = [
	preload("res://source/materials/procedural.tres"),
	preload("res://source/materials/glass.tres")
]


func _ready() -> void:
	material_list_button_popup.id_pressed.connect(_on_MaterialListButton_id_pressed)


func _on_MaterialListButton_id_pressed(id: int) -> void:
	material_list_button_popup.set_item_checked(id, true)
	for i in material_list_button_popup.item_count:
		if i != id:
			material_list_button_popup.set_item_checked(i, false)
	
	editor.set_selected_objects_property(variable_name, materials[id])


func _on_check_box_toggled(toggled_on:bool) -> void:
	editor.set_selected_objects_property(variable_name, toggled_on)


func _on_material_option_button_item_selected(index:int) -> void:
	editor.set_selected_objects_property(variable_name, materials[index])


func _on_spin_box_value_changed(value:float) -> void:
	editor.set_selected_objects_property(variable_name, value)


func _on_spin_box_x_value_changed(value:float) -> void:
	variable_vector3.x = value
	editor.set_selected_objects_property(variable_name, variable_vector3)


func _on_spin_box_y_value_changed(value:float) -> void:
	variable_vector3.y = value
	editor.set_selected_objects_property(variable_name, variable_vector3)


func _on_spin_box_z_value_changed(value:float) -> void:
	variable_vector3.z = value
	editor.set_selected_objects_property(variable_name, variable_vector3)


func _on_line_edit_text_changed(new_text: String) -> void:
	editor.set_selected_objects_property(variable_name, new_text)
