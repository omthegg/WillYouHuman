extends Node3D

@onready var PlayerCamera:Node3D = $PlayerCamera
@onready var Grid:StaticBody3D = $Grid
@onready var property_menu:Control = $UI/PropertyMenu
#@onready var cursor:Node3D = $"3DCursor"

var selected_objects:Array = []

var selected_scene:PackedScene

var editible_variables:Dictionary = {
	"material" = Variant.Type.TYPE_OBJECT,
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
	if selected_objects.size() == 0:
		property_menu.hide()
	else:
		property_menu.show()
