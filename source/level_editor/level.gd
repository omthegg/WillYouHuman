extends Node3D

@export var networks:Array = []

class Network:
	var powered:bool = false
	var devices:Array = []
	var wires:Array = [] # This is only for knowing the wires to show as powered

# When connecting two devices together, first create a new network
# If the object with updated wiring is in two networks at the same time,
# merge the two networks
# Create wires when first connecting two devices

func create_network(wires:Array, devices:Array) -> Network:
	var network:Network = Network.new()
	network.wires = wires
	network.devices = devices
	networks.append(network)
	return network


func set_network_power(network:Network, powered:bool) -> void:
	network.powered = powered


func merge_overlapping_networks(network1:Network, network2:Network, overlapping_device:Object) -> Network:
	var merged_network:Network = network1
	merged_network.devices.erase(overlapping_device)
	merged_network.devices.append_array(network2.devices)
	merged_network.wires.append_array(network2.wires)
	networks.append(merged_network)
	return merged_network


func update_networks() -> void:
	pass
