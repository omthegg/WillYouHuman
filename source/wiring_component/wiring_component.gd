extends Area3D

var dragged_wire:Node3D


func _on_body_entered(body:Node3D) -> void:
	if !body.is_in_group("player"):
		return
	
	# I had to nest this code
	if body.dragged_wire:
		if is_instance_valid(body.dragged_wire):
			if self in body.dragged_wire.devices:
				return
			else:
				body.dragged_wire.queue_free()
	
	var wire:Node3D = Global.scene_manager.wire.instantiate()
	Global.scene_manager.add_child(wire)
	wire.devices = [self, body]
	body.dragged_wire = wire
