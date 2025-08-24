extends Area3D

var dragged_wire:Node3D


func _on_body_entered(body):
	if !body.is_in_group("player"):
		return
	if !body.dragged_wire:
		return
	if !is_instance_valid(body.dragged_wire):
		return
	if self in body.dragged_wire.devices:
		return
	
	var wire:Node3D = Global.scene_manager.wire.instantiate()
	Global.scene_manager.add_child(wire)
	wire.devices = [self, body]
	body.dragged_wire = wire
