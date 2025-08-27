extends Node

var procedural_material:StandardMaterial3D = preload("res://source/materials/procedural.tres")
var glass_material:StandardMaterial3D = preload("res://source/materials/glass.tres")
var antenna_material:StandardMaterial3D = preload("res://source/short_range_antenna/antenna.tres")
var wire_material:StandardMaterial3D = preload("res://source/wire/wire.tres")
var player_material:StandardMaterial3D = preload("res://source/player/player_material1.tres")
var wire_range_material:StandardMaterial3D = preload("res://source/wiring_component/range_material.tres")

func _ready() -> void:
	procedural_material.albedo_texture = Global.generate_random_texture()
	procedural_material.albedo_color = Color.ORANGE
	glass_material.albedo_color = Color.BLUE
	antenna_material.albedo_color = Color.BLUE
	wire_material.albedo_color = Color.LIGHT_SKY_BLUE
	player_material.albedo_color = Color.GREEN
	wire_range_material.albedo_color = Color.DODGER_BLUE
	wire_range_material.albedo_color.a = 0.1
