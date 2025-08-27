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
	update_network_devices_labels(network)
	update_network_wires_labels(network)
	return network


func set_network_power(network:Network, powered:bool) -> void:
	network.powered = powered


func merge_overlapping_networks(network1:Network, network2:Network, overlapping_device:Object) -> Network:
	var merged_network:Network = network1
	merged_network.devices.erase(overlapping_device)
	merged_network.devices.append_array(network2.devices)
	merged_network.wires.append_array(network2.wires)
	networks.append(merged_network)
	update_network_devices_labels(merged_network)
	update_network_wires_labels(merged_network)
	return merged_network


func update_networks() -> void:
	pass


func update_network_devices_labels(network:Network) -> void:
	for device in network.devices:
		device.display_network_id(network)


func update_network_wires_labels(network:Network) -> void:
	for wire in network.wires:
		wire.display_network_id(network)


func fix_network_overlap(network:Network, overlapping_device:Object) -> Network:
	for n:Network in networks:
		if n == network:
			continue
		if !(overlapping_device in n.devices):
			continue
		
		var merged_network = merge_overlapping_networks(network, n, overlapping_device)
		#print("E")
		return merged_network
	
	#print("F")
	update_network_devices_labels(network)
	update_network_wires_labels(network)
	return network
