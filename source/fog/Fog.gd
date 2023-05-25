tool
extends Spatial

export var box_extents:Vector3 = Vector3(2, 2, 2) setget set_extends
export var amount:int = 256 setget set_amount
export var lifetime:float = 1.0 setget set_lifetime
export var recieve_level_color:bool = false setget set_recieve_level_color
export var particle_size:Vector2 = Vector2(1, 1) setget set_particle_size

func set_extends(value):
	box_extents = value
	$Particles.process_material.set_emission_box_extents(box_extents)
	$Particles.visibility_aabb = AABB(-box_extents, box_extents * 2)

func set_amount(value):
	amount = value
	$Particles.amount = value

func set_lifetime(value):
	lifetime = value
	$Particles.lifetime = value

func set_recieve_level_color(value):
	recieve_level_color = value
	#if recieve_level_color:
	#	var root_node = get_tree().get_root().get_child(0)
	#	if root_node.get("color") != null:
	#		var lc = root_node.color # Stands for "level color"
	#		$Particles.material_override.albedo_color.r = lc.r
	#		$Particles.material_override.albedo_color.g = lc.g
	#		$Particles.material_override.albedo_color.b = lc.b

func set_particle_size(value):
	particle_size = value
	$Particles.draw_pass_1.size = value

func _process(_delta):
	if recieve_level_color:
		if Global.get("map"):
			var lc = Global.map.color
			$Particles.material_override.albedo_color.r = lc.r
			$Particles.material_override.albedo_color.g = lc.g
			$Particles.material_override.albedo_color.b = lc.b
