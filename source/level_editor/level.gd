extends Node3D

@export var networks:Array = []

var visited_neighbors = [] # See get_neighbors_recursive

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
		if !is_instance_valid(wire):
			continue
		
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
	
	if device2 in get_neighbors(device1):
		return
	
	var new_network:Network = Network.new()
	
	network.devices.erase(device2)
	var device2_neighbors:Array = get_neighbors(device2)
	for neighbor in device2_neighbors:
		network.devices.erase(neighbor)
		#if !is_instance_valid(network):
		#	networks.erase(network)
		#	continue
		for w in network.wires:
			if !is_instance_valid(w):
				network.wires.erase(w)
				continue
			
			if neighbor in w.devices:
				new_network.wires.append(w)
				network.wires.erase(w)
	
	new_network.devices.append_array(device2_neighbors)
	new_network.devices.append(device2)
	
	network.wires.erase(wire)
	new_network.wires.erase(wire)
	wire.queue_free()
	
	update_network(network)
	update_network(new_network)
	
	if network.devices.size() < 2:
		networks.erase(network)
		device1.label.text = "Network"
	if new_network.devices.size() < 2:
		networks.erase(new_network)
		device2.label.text = "Network"
	
	erase_network_duplicates()
	erase_stray_wires()
	
	for n in networks:
		update_network(n)
	
	print("---Networks---")
	for n in networks:
		print("Network id: ", str(network))
		print("Devices: ")
		print(n.devices)
		print("Wires: ")
		print(n.wires)
	
	
	# TODO: Erase stray networks


# This function works as intended.
func get_neighbors(device:Node3D) -> Array:
	visited_neighbors = []
	return Global.erase_duplicates(get_neighbors_recursive(device))


func get_neighbors_recursive(device:Node3D, neighbors_list:Array=[]) -> Array:
	var neighbors = []
	visited_neighbors.append(device)
	for neighbor in device.neighbor_devices:
		if !(neighbor in visited_neighbors):
			neighbors.append(neighbor)
			neighbors += get_neighbors_recursive(neighbor, neighbors)
	
	return neighbors


func get_wire_between_devices(device1:Node3D, device2:Node3D) -> Node3D:
	for network in networks:
		for wire in network.wires:
			if !is_instance_valid(wire):
				continue
			
			if (device1 in wire.devices) and (device2 in wire.devices):
				return wire
	
	return null


func erase_network_duplicates() -> void:
	networks = Global.erase_duplicates(networks)
	for n in networks:
		n.devices = Global.erase_duplicates(n.devices)
		n.wires = Global.erase_duplicates(n.wires)


func erase_stray_wires() -> void:
	for child in get_children():
		if !child.is_in_group("wire"):
			continue
		
		var in_a_network:bool = false
		for network in networks:
			if child in network.wires:
				in_a_network = true
				break
		
		if !in_a_network:
			child.queue_free()


func update_debug_info() -> void:
	for child in get_children():
		if !child.get_node_or_null("WiringComponent"):
			continue
		
		var device = child.get_node("WiringComponent")
		device.get_node("Label3D2").text = str(get_neighbors(device)).replace(",", "\n")
		device.get_node("Label3D3").text = str(device)
