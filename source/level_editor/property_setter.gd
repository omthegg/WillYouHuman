extends Control

@onready var editor:Node3D = get_tree().root.get_node("LevelEditor")

@onready var material_list_button:MenuButton = $MaterialListButton
@onready var material_list_button_popup:PopupMenu = material_list_button.get_popup()
@onready var material_option_button:OptionButton = $MaterialOptionButton
@onready var material_option_button_popup:PopupMenu = material_option_button.get_popup()
@onready var label:Label = $Label
@onready var line_edit:LineEdit = $LineEdit
@onready var spinbox:SpinBox = $SpinBox
@onready var checkbox:CheckBox = $CheckBox


var variable_name:String = "":
	set(value):
		variable_name = value
		var type:int = editor.editable_variables.get(variable_name)
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
				
				label.text = variable_name
				label.show()
				material_option_button.show()
				var index:int = 0
				for i in material_option_button_popup.item_count:
					if material_option_button_popup.get_item_text(i) == material_name:
						id = material_option_button_popup.get_item_id(i)
				
				material_option_button.select(index)
			
			TYPE_BOOL:
				checkbox.text = variable_name.capitalize()
				checkbox.show()
				checkbox.button_pressed = editor.selected_objects[0].get(variable_name)
				


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


func _on_check_box_toggled(toggled_on):
	editor.set_selected_objects_property(variable_name, toggled_on)


func _on_material_option_button_item_selected(index):
	editor.set_selected_objects_property(variable_name, materials[index])
