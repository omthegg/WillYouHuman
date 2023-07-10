extends "res://source/Polygon3D/Polygon3D.gd"

onready var outline_mesh_instance = $OutlineMeshInstance
onready var area_collision_shape = $Area/CollisionShape

var velocity = Vector3(0, 0, 0)
var previous_position:Vector3

var bodies = []

func _ready():
	if Global.editing_level:
		$MeshInstance.hide()
		var m = SpatialMaterial.new()
		m.albedo_color = Color.aquamarine
		m.flags_unshaded = true
		#yield(get_tree(), "idle_frame")
		outline_mesh_instance.material_override = m
	else:
		collision_shape.disabled = true
		hide()
	
	previous_position = global_transform.origin

func _physics_process(_delta):
	area_collision_shape.shape = collision_shape.shape  # This is bad
	if Global.editing_level:
		outline_mesh_instance.mesh = collision_shape.shape.get_debug_mesh()
	else:
		velocity = global_transform.origin - previous_position
		
		for body in bodies:
			body.global_transform.origin += velocity
		
		previous_position = global_transform.origin


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		bodies.append(body)

func _on_Area_body_exited(body):
	bodies.erase(body)
