extends Node

var procedural_material:StandardMaterial3D = preload("res://source/materials/procedural.tres")
var glass_material:StandardMaterial3D = preload("res://source/materials/glass.tres")
var antenna_material:StandardMaterial3D = preload("res://source/short_range_antenna/antenna.tres")
var wire_material:StandardMaterial3D = preload("res://source/wire/wire_material.tres")
var player_material:StandardMaterial3D = preload("res://source/player/player_material1.tres")
var wire_range_material:StandardMaterial3D = preload("res://source/wiring_component/range_material.tres")
var wire_powered_material:StandardMaterial3D = preload("res://source/wire/wire_powered_material.tres")
var bomb_material:StandardMaterial3D = preload("res://source/bomb/bomb_material.tres")
var button_top_material:StandardMaterial3D = preload("res://source/button/button_top_material.tres")
var button_base_material:StandardMaterial3D = preload("res://source/button/button_base_material.tres")
var button_top_material_activated:StandardMaterial3D = preload("res://source/button/button_top_material_activated.tres")
var button_base_material_activated:StandardMaterial3D = preload("res://source/button/button_base_material_activated.tres")

func _ready() -> void:
	procedural_material.albedo_texture = Global.generate_random_texture()
	procedural_material.albedo_color = Color.ORANGE
	glass_material.albedo_color = Color.BLUE
	antenna_material.albedo_color = Color.BLUE
	wire_material.albedo_color = Color.LIGHT_SKY_BLUE
	player_material.albedo_color = Color.GREEN
	wire_range_material.albedo_color = Color.DODGER_BLUE
	wire_range_material.albedo_color.a = 0.1
	wire_powered_material.albedo_color = Color.WHITE
	bomb_material.albedo_color = Color.RED
	button_top_material.albedo_color = Color.ROYAL_BLUE
	button_base_material.albedo_color = Color.BLUE
	button_top_material_activated.albedo_color = Color.ORANGE_RED
	button_base_material_activated.albedo_color = Color.RED
