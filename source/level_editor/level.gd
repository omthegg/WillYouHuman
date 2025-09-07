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

# When disconnecting two devices from each other, go through all neighbor devices
# and put them in a new network


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
	merged_network.devices = Global.erase_duplicates(merged_network.devices)
	merged_network.wires = Global.erase_duplicates(merged_network.wires)
	networks.append(merged_network)
	update_network(merged_network)
	return merged_network


func update_network(network:Network) -> void:
	#print(network.devices.size())
	for device in network.devices:
		if device.is_source:
			network.powered = true
		
		device.powered = network.powered
		device.display_network_id(network)
	
	for wire in network.wires:
		wire.powered = network.powered
		wire.display_network_id(network)
		wire.update_model()


func fix_network_overlap(network:Network, overlapping_device:Object) -> void:# -> Network:
	for n:Network in networks:
		if networks.size() == 1:
			#print("E")
			return
		
		if n == network:
			continue
		if !(overlapping_device in n.devices):
			continue
		
		var merged_network = merge_overlapping_networks(network, n, overlapping_device)
		
		#print(str(n))
		#return merged_network
	
	#print("F")
	#update_network(network)
	#return network


func split_network_by_wire(wire:Node3D) -> void:
	var network:Network
	for n:Network in networks:
		if wire in n.wires:
			network = n
	
	if !network:
		return
	
	var device1 = wire.devices[0]
	var device2 = wire.devices[1]
	
	device1.neighbor_devices.erase(device2)
	device2.neighbor_devices.erase(device1)
	
	if device2 in get_neighbors_recursive(device1):
		return
	
	var new_network:Network = Network.new()
	
	network.devices.erase(device2)
	var device2_neighbors:Array = get_neighbors_recursive(device2)
	for neighbor in device2_neighbors:
		network.devices.erase(neighbor)
		for w in network.wires:
			if neighbor in w.devices:
				new_network.wires.append(w)
	
	new_network.devices += device2_neighbors
	new_network.append(device2)
	
	update_network(network)
	update_network(new_network)
	#network.devices -= get_neighbors_recursive(device2)


func get_neighbors_recursive(device:Node3D) -> Array:
	var neighbors = []
	for neighbor in device.neighbor_devices:
		neighbors += get_neighbors_recursive(neighbor)
	
	return neighbors
