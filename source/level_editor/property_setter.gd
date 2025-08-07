extends Control

@onready var editor:Node3D = get_tree().root.get_node("LevelEditor")

@onready var material_button:MenuButton = $MaterialButton
@onready var material_button_popup:PopupMenu = material_button.get_popup()
@onready var label:Label = $Label
@onready var line_edit:LineEdit = $LineEdit
@onready var spinbox:SpinBox = $SpinBox


var variable_name:String = "":
	set(value):
		variable_name = value
		var type:int = editor.editable_variables.get(variable_name)
		match type:
			TYPE_OBJECT:
				material_button.show()
				var material_name:String = editor.selected_objects[0].get(variable_name).resource_name
				var id:int = 0
				for i in material_button_popup.item_count:
					if material_button_popup.get_item_text(i) == material_name:
						id = material_button_popup.get_item_id(i)
				
				material_button_popup.set_item_checked(id, true)
				#material_button.text = "Material: " + 


var materials = [
	preload("res://source/materials/procedural.tres"),
	preload("res://source/materials/glass.tres")
]


func _ready() -> void:
	material_button_popup.id_pressed.connect(_on_MaterialButton_id_pressed)


func _on_MaterialButton_id_pressed(id: int) -> void:
	material_button_popup.set_item_checked(id, true)
	for i in material_button_popup.item_count:
		if i != id:
			material_button_popup.set_item_checked(i, false)
