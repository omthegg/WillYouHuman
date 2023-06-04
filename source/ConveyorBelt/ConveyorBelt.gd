extends StaticBody

export var ending_point:Vector3 = Vector3(0, 0, -2) setget set_ending_point
export var width:float = 2.0
export var speed:float = 10.0

var material = preload("res://source/ConveyorBelt/ConveyorBelt.tres")

onready var mesh_instance = $MeshInstance

onready var top = $Top
onready var bottom = $Bottom
onready var front = $Front
onready var back = $Back
onready var left = $Left
onready var right = $Right

onready var collision_shape = $CollisionShape
onready var area_collision_shape = $Area/CollisionShape

var bodies = []

func _ready():
	top.material_override = material.duplicate()
	bottom.material_override = top.material_override
	front.material_override = material.duplicate()
	back.material_override = front.material_override
	left.material_override = SpatialMaterial.new()
	right.material_override = left.material_override
	
	top.material_override.resource_local_to_scene = true
	bottom.material_override.resource_local_to_scene = true
	front.material_override.resource_local_to_scene = true
	back.material_override.resource_local_to_scene = true
	left.material_override.resource_local_to_scene = true
	right.material_override.resource_local_to_scene = true
	
	# Assume the grand grand parent is the map node
	top.material_override.albedo_color = get_parent().get_parent().get_parent().color
	bottom.material_override.albedo_color = get_parent().get_parent().get_parent().color
	front.material_override.albedo_color = get_parent().get_parent().get_parent().color
	back.material_override.albedo_color = get_parent().get_parent().get_parent().color
	left.material_override.albedo_color = get_parent().get_parent().get_parent().color
	right.material_override.albedo_color = get_parent().get_parent().get_parent().color


func set_ending_point(value):
	ending_point = value
	if !get_parent():
		yield(self, "ready")
	
	top.mesh.size.y = ending_point.length()
	bottom.mesh.size.y = ending_point.length()
	left.mesh.size.x = ending_point.length()
	right.mesh.size.x = ending_point.length()
	
	top.translation.z = -ending_point.length()/2 + 1
	bottom.translation.z = -ending_point.length()/2 + 1
	left.translation.z = -ending_point.length()/2 + 1
	right.translation.z = -ending_point.length()/2 + 1
	front.translation.z = -ending_point.length() + 1
	#back.translation.z = -ending_point.length()/2
	
	collision_shape.shape.extents.z = ending_point.length()/2
	collision_shape.translation.z = -ending_point.length()/2 + 1
	
	area_collision_shape.shape.extents.z = ending_point.length()/2
	area_collision_shape.translation.z = -ending_point.length()/2 + 1
	
	mesh_instance.mesh.size.z = ending_point.length()
	mesh_instance.translation.z = (-ending_point.length() + 2)/2
	
	look_at(global_transform.origin + ending_point, Vector3.UP)


func _physics_process(delta):
	if !Global.editing_level:
		for body in bodies:
			if body is KinematicBody:
				body.global_transform.origin += speed * -global_transform.basis.z * delta
			if body is RigidBody:
				body.set_axis_velocity(speed * -global_transform.basis.z)


func _process(delta):
	if speed > 0:
		top.material_override.uv1_scale.z = 0.5
		bottom.material_override.uv1_scale.z = 0.5
		front.material_override.uv1_scale.z = 0.5
		back.material_override.uv1_scale.z = 0.5
	elif speed < 0:
		top.material_override.uv1_scale.z = -0.5
		bottom.material_override.uv1_scale.z = -0.5
		front.material_override.uv1_scale.z = -0.5
		back.material_override.uv1_scale.z = -0.5
	
	top.material_override.uv1_offset.z += speed/4 * delta
	bottom.material_override.uv1_offset.z += speed/4 * delta
	front.material_override.uv1_offset.z += speed/4 * delta
	back.material_override.uv1_offset.z += speed/4 * delta


func _on_Area_body_entered(body):
	if !(body in bodies):
		bodies.append(body)
		if body is RigidBody:
			body.linear_velocity = Vector3.ZERO


func _on_Area_body_exited(body):
	if body in bodies:
		bodies.erase(body)
		#if body is RigidBody:
		#	body.linear_velocity = Vector3.ZERO
