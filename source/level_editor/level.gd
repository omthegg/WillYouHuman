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
	update_network(network)
	return network


func set_network_power(network:Network, powered:bool) -> void:
	network.powered = powered


func merge_overlapping_networks(network1:Network, network2:Network, overlapping_device:Object) -> Network:
	if network1 == network2:
		return network1
	
	var merged_network:Network = network1
	merged_network.devices.erase(overlapping_device)
	merged_network.devices.append_array(network2.devices)
	merged_network.wires.append_array(network2.wires)
	networks.append(merged_network)
	update_network(merged_network)
	return merged_network


func update_network(network:Network) -> void:
	for device in network.devices:
		if device.is_source:
			network.powered = true
		
		device.powered = network.powered
		#device.display_network_id(network)
	
	#for wire in network.wires:
	#	wire.powered = network.powered
		#wire.display_network_id(network)


func fix_network_overlap(network:Network, overlapping_device:Object) -> void:# -> Network:
	for n:Network in networks:
		if networks.size() == 1:
			print("E")
			return
		
		if n == network:
			continue
		if !(overlapping_device in n.devices):
			continue
		
		var merged_network = merge_overlapping_networks(network, n, overlapping_device)
		
		print(str(n))
		#return merged_network
	
	#print("F")
	#update_network(network)
	#return network
