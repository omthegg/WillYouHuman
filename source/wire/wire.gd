extends Node3D

var powered:bool = false

@export var devices:Array = []:
	set(value):
		devices = value
		update_model()

@onready var mesh_instance:MeshInstance3D = $MeshInstance3D
@onready var label:Label3D = $Label3D
@onready var raycast:RayCast3D = $RayCast3D
@onready var power_indicator:MeshInstance3D = $PowerIndicator

func update_model() -> void:
	if devices.size() != 2:
		return
	
	var pos1:Vector3 = devices[0].global_position
	var pos2:Vector3 = devices[1].global_position
	if devices[0].get_node_or_null("Outlet"):
		pos1 = devices[0].get_node("Outlet").global_position
	if devices[1].get_node_or_null("Outlet"):
		pos2 = devices[1].get_node("Outlet").global_position
	
	var distance:float = pos1.distance_to(pos2)
	mesh_instance.mesh.height = distance
	power_indicator.mesh.height = distance
	var mid_point:Vector3 = (pos1 + pos2)/2
	global_position = mid_point
	look_at(pos1)
	power_indicator.visible = powered
	#if devices[0].is_in_group("antenna") and devices[1].is_in_group("antenna"):
	#	power_indicator.visible = devices[0].powered and devices[1].powered
	#else:
	#	power_indicator.hide()


func _physics_process(_delta) -> void:
	update_model()


func display_network_id(network) -> void:
	label.text = "Network: " + str(network)
