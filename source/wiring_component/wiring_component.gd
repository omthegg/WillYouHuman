extends Area3D

@export var limited_range:bool = true
@export var is_source:bool = false

@onready var label:Label3D = $Label3D
@onready var range_mesh_instance:MeshInstance3D = $Range/MeshInstance3D
@onready var range:Area3D = $Range

var neighbor_devices:Array = []

var powered:bool = false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	if !Global.is_in_level_editor(self):
		set_collision_layer_value(4, true)
		set_collision_mask_value(4, true)
		range.set_collision_layer_value(4, true)
		range.set_collision_mask_value(4, true)


func _on_body_entered(body:Node3D) -> void:
	if !body.is_in_group("player"):
		return
	
	if player_has_dragged_wire(body):
		if self in body.dragged_wire.devices:
			return
		
		var previous_wire_devices = body.dragged_wire.devices.duplicate()
		previous_wire_devices.erase(body)
		var other_device = previous_wire_devices[0]
		
		body.dragged_wire.queue_free()
		if other_device in neighbor_devices:
			body.dragged_wire = create_wire([self, body])
			return
		
		var new_wire = create_wire([self, other_device])
		var network = Global.scene_manager.current_level.create_network([new_wire], [self, other_device])
		#var fixed_network = 
		Global.scene_manager.current_level.fix_network_overlap(network, self)
		#fixed_network = 
		Global.scene_manager.current_level.fix_network_overlap(network, other_device)
		#display_network_id(fixed_network)
		#other_device.display_network_id(fixed_network)
		other_device.neighbor_devices.append(self)
		neighbor_devices.append(other_device)
		if other_device.limited_range:
			other_device.range_mesh_instance.hide()
	
	body.dragged_wire = create_wire([self, body])
	if limited_range:
		range_mesh_instance.show()


func player_has_dragged_wire(player:Node3D) -> bool:
	return player.dragged_wire and is_instance_valid(player.dragged_wire)


func display_network_id(network) -> void:
	label.text = "Network: " + str(network)


func create_wire(devices:Array) -> Node3D:
	var wire:Node3D = Global.scene_manager.wire.instantiate()
	Global.scene_manager.current_level.add_child(wire)
	wire.devices = devices
	return wire


func _on_range_body_exited(body:Node3D) -> void:
	if !limited_range:
		return
	
	if !body.is_in_group("player"):
		return
	
	if !player_has_dragged_wire(body):
		return
	
	if self in body.dragged_wire.devices:
		body.dragged_wire.queue_free()
		range_mesh_instance.hide()
