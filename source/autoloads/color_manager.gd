extends Node

var procedural_material:StandardMaterial3D = preload("res://source/materials/procedural.tres")
var glass_material:StandardMaterial3D = preload("res://source/materials/glass.tres")
var antenna_material:StandardMaterial3D = preload("res://source/materials/antenna.tres")
var wire_material:StandardMaterial3D = preload("res://source/materials/wire.tres")

func _ready() -> void:
	procedural_material.albedo_texture = Global.generate_random_texture()
	procedural_material.albedo_color = Color.ORANGE
	glass_material.albedo_color = Color.BLUE
	antenna_material.albedo_color = Color.BLUE
	wire_material.albedo_color = Color.LIGHT_SKY_BLUE
