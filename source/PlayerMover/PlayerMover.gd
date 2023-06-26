extends "res://source/Polygon3D/Polygon3D.gd"

onready var outline_mesh_instance = $OutlineMeshInstance

var velocities = []

func _ready():
	if Global.editing_level:
		$MeshInstance.hide()
		var m = SpatialMaterial.new()
		m.albedo_color = Color.aquamarine
		m.flags_unshaded = true
		#yield(get_tree(), "idle_frame")
		outline_mesh_instance.material_override = m
	else:
		hide()

func _physics_process(_delta): # This is bad
	if Global.editing_level:
		outline_mesh_instance.mesh = collision_shape.shape.get_debug_mesh()

func add_stop_time(time:float):
	var timer = Timer.new()
	add_child(timer)
	timer.time_left = time
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout():
	pass
