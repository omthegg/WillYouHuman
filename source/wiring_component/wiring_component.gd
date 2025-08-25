extends Area3D

var neighbor_devices:Array = []

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	if !Global.is_in_level_editor(self):
		set_collision_layer_value(4, true)
		set_collision_mask_value(4, true)


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
		display_network_id(network)
		other_device.display_network_id(network)
		other_device.neighbor_devices.append(self)
		neighbor_devices.append(other_device)
	
	body.dragged_wire = create_wire([self, body])


func player_has_dragged_wire(player:Node3D) -> bool:
	return player.dragged_wire and is_instance_valid(player.dragged_wire)


func display_network_id(network) -> void:
	$Label3D.text = "Network: " + str(network)


func create_wire(devices:Array) -> Node3D:
	var wire:Node3D = Global.scene_manager.wire.instantiate()
	Global.scene_manager.current_level.add_child(wire)
	wire.devices = devices
	return wire
