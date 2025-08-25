extends Area3D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	if !Global.is_in_level_editor(self):
		set_collision_layer_value(4, true)
		set_collision_mask_value(4, true)


func _on_body_entered(body:Node3D) -> void:
	if !body.is_in_group("player"):
		return
	
	#print(str(get_parent()))
	# I had to nest this code
	if body.dragged_wire:
		if is_instance_valid(body.dragged_wire):
			if self in body.dragged_wire.devices:
				return
			else:
				var previous_wire_devices = body.dragged_wire.devices
				previous_wire_devices.erase(body)
				var other_device = previous_wire_devices[0]
				var new_wire = create_wire([self, other_device])
				body.dragged_wire.queue_free()
				var network = Global.scene_manager.current_level.create_network([new_wire], [self, other_device])
				$Label3D.text = "Network: " + str(network)
				other_device.get_node("Label3D").text = "Network: " + str(network)
	
	body.dragged_wire = create_wire([self, body])


func create_wire(devices:Array) -> Node3D:
	var wire:Node3D = Global.scene_manager.wire.instantiate()
	Global.scene_manager.current_level.add_child(wire)
	wire.devices = devices
	return wire
