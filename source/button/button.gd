extends StaticBody3D

@export var one_time_press:bool = false

@onready var base:MeshInstance3D = $Base
@onready var top:MeshInstance3D = $Top
@onready var wiring_component:Area3D = $WiringComponent

func press() -> void:
	top.position.y = 0.15
	top.material_override = ColorManager.button_top_material_activated
	base.material_override = ColorManager.button_base_material_activated
	wiring_component.is_source = true


func unpress() -> void:
	top.position.y = 0.3
	top.material_override = ColorManager.button_top_material
	base.material_override = ColorManager.button_base_material
	wiring_component.is_source = false


func _on_area_3d_body_entered(body:Node3D) -> void:
	if !body.is_in_group("player"):
		return
	
	press()


func _on_area_3d_body_exited(body:Node3D) -> void:
	if !body.is_in_group("player"):
		return
	
	if one_time_press:
		return
	
	unpress()
	
