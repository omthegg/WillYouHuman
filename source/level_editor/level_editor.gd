extends Node3D

@onready var PlayerCamera:Node3D = $PlayerCamera
@onready var Grid:StaticBody3D = $Grid
@onready var cursor:Node3D = %"3DCursor"

func _physics_process(_delta: float) -> void:
	Grid.position.x = PlayerCamera.position.x
	Grid.position.z = PlayerCamera.position.z
	
	if Input.is_action_just_pressed("ObjectMenu"):
		%ObjectMenu.visible = !%ObjectMenu.visible


func _on_grid_spin_box_value_changed(value: float) -> void:
	Grid.position.y = value
	%GridSpinBox.get_line_edit().release_focus()
