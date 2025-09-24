extends Node3D

@export var networks:Array = []
@export var indexed_networks:Array = []

var player:CharacterBody3D

var visited_neighbors = [] # See get_neighbors_recursive

class Network:
	var powered:bool = false
	var devices:Array = []
	var wires:Array = [] # This is only for knowing the wires to show as powered

var empty_network:Dictionary = {
	"powered" = false,
	"devices" = [],
	"wires" = []
}


# When connecting two devices together, first create a new network
# If the object with updated wiring is in two networks at the same time,
# merge the two networks
# Create wires when first connecting two devices

# When disconnecting two devices from each other, go through all neighbor devices
# and put them in a new network

# TODO: Make networks dictionaries instead of classes (because classes get freed)

func _ready() -> void:
	for child in get_children():
		if child.is_in_group("player"):
			player = child
			break


func _physics_process(_delta: float) -> void:
	if !Global.is_in_level_editor(self):
		for network in networks:
			update_network(network)


func connect_devices(device1:NodePath, device2:NodePath) -> void:
	if device1 == device2:
		return
	
	var new_wire = create_wire([device1, device2])
	var network = create_network([get_path_to(new_wire)], [device1, device2])
	#var fixed_network = 
	fix_network_overlap(network, device1)
	#fixed_network = 
	fix_network_overlap(network, device2)
	#display_network_id(fixed_network)
	#other_device.display_network_id(fixed_network)
	get_node(device1).neighbor_devices.append(device2)
	get_node(device2).neighbor_devices.append(device1)


func create_wire(devices:Array) -> Node3D:
	var wire:Node3D = Global.scene_manager.wire.instantiate()
	add_child(wire, true)
	wire.devices = devices
	return wire


func create_network(wires:Array, devices:Array) -> Dictionary:
	var network:Dictionary = empty_network.duplicate(true)
	network["wires"] = wires
	network["devices"] = devices
	networks.append(network)
	update_network(network)
	return network


func set_network_power(network:Network, powered:bool) -> void:
	network["powered"] = powered


func merge_overlapping_networks(network1:Dictionary, network2:Dictionary, overlapping_device:NodePath) -> Dictionary:
	if network1 == network2:
		return network1
	
	var merged_network:Dictionary = network1
	merged_network["devices"].erase(overlapping_device)
	merged_network["devices"].append_array(network2["devices"])
	merged_network["wires"].append_array(network2["wires"])
	merged_network["devices"] = Global.erase_duplicates(merged_network["devices"])
	merged_network["wires"] = Global.erase_duplicates(merged_network["wires"])
	networks.append(merged_network)
	update_network(merged_network)
	networks.erase(network2)
	erase_network_duplicates()
	return merged_network


func update_network(network:Dictionary) -> void:
	#print(network.devices.size())
	var has_power_source:bool = false
	if network in indexed_networks:
		return
	
	for device in network.devices:
		if get_node(device).get("is_source"):
			has_power_source = true
	
	network["powered"] = has_power_source
	
	for device in network.devices:
		if get_node(device).get("powered") == null:
			continue
		
		get_node(device).powered = network["powered"]
		get_node(device).display_network_id(network)
	
	for wire in network.wires:
		if !is_instance_valid(get_node_or_null(wire)):
			continue
		
		get_node(wire).powered = network["powered"]
		get_node(wire).display_network_id(network)
		get_node(wire).update_model()
	
	#if (network.devices.size() < 2) or (network.wires.size() < 1):
	#	for device in network.devices:
	#		device.label.text = "Network"
	#	networks.erase(network)


func fix_network_overlap(network:Dictionary, overlapping_device:NodePath) -> void:# -> Network:
	for n:Dictionary in networks:
		if networks.size() == 1:
			#print("E")
			return
		
		if n == network:
			continue
		if !(overlapping_device in n["devices"]):
			continue
		#print("E")
		
		var merged_network = merge_overlapping_networks(network, n, overlapping_device)
		#print(str(merged_network))


func split_network_by_wire(wire:NodePath) -> void:
	var network:Dictionary
	for n:Dictionary in networks:
		if wire in n["wires"]:
			network = n
	
	if !network:
		return
	
	var device1 = get_node(wire).devices[0]
	var device2 = get_node(wire).devices[1]
	
	erase_network_duplicates()
	
	get_node(device1).neighbor_devices.erase(device2)
	get_node(device2).neighbor_devices.erase(device1)
	
	network["wires"].erase(wire)
	#new_network.wires.erase(wire)
	get_node(wire).queue_free()
	
	if device2 in get_neighbors(device1):
		return
	
	var new_network:Dictionary = create_network([], [])
	
	network["devices"].erase(device2)
	new_network["devices"].append(device2)
	var device2_neighbors:Array = get_neighbors(device2)
	for neighbor in device2_neighbors:
		network["devices"].erase(neighbor)
		new_network["devices"].append(neighbor)
		#if !is_instance_valid(network):
		#	networks.erase(network)
		#	continue
		for w in network.wires:
			if !is_instance_valid(get_node_or_null(w)):
				network["wires"].erase(w)
				continue
			
			if neighbor in get_node(w).devices:
				new_network["wires"].append(w)
				network["wires"].erase(w)
	
	#new_network.devices.append_array(device2_neighbors)
	
	update_network(network)
	update_network(new_network)
	
	fix_network_overlap(network, device1)
	fix_network_overlap(new_network, device2)
	#for device in network.devices:
	#	fix_network_overlap(network, device)
	#for device in network.devices:
	#	fix_network_overlap(new_network, device)
	
	#if network.devices.size() < 2:
	#	networks.erase(network)
	#	device1.label.text = "Network"
	#if new_network.devices.size() < 2:
	#	networks.erase(new_network)
	#	device2.label.text = "Network"
	
	erase_network_duplicates()
	#erase_stray_wires()
	
	#for n:Network in networks:
	#	update_network(n)
	
	#for n:Network in networks:
	#	print(str(n.devices))


func get_neighbors(device:NodePath) -> Array:
	visited_neighbors = []
	return Global.erase_duplicates(get_neighbors_recursive(device))


func get_neighbors_recursive(device:NodePath, neighbors_list:Array=[]) -> Array:
	var neighbors = []
	visited_neighbors.append(device)
	for neighbor in get_node(device).neighbor_devices:
		if !(neighbor in visited_neighbors):
			neighbors.append(neighbor)
			neighbors += get_neighbors_recursive(neighbor, neighbors)
	
	return neighbors


func get_wire_between_devices(device1:NodePath, device2:NodePath) -> NodePath:
	for network in networks:
		for wire in network["wires"]:
			if !is_instance_valid(get_node_or_null(wire)):
				continue
			
			if (device1 in get_node(wire).devices) and (device2 in get_node(wire).devices):
				return wire
	
	return NodePath("")


func erase_network_duplicates() -> void:
	networks = Global.erase_duplicates(networks)
	for n in networks:
		n["devices"] = Global.erase_duplicates(n["devices"])
		n["wires"] = Global.erase_duplicates(n["wires"])


func erase_stray_wires() -> void:
	for child in get_children():
		if !child.is_in_group("wire"):
			continue
		
		if Global.is_in_level_editor(self):
			if child == Global.scene_manager.level_editor.player_camera.dragged_wire:
				continue
		
		var in_a_network:bool = false
		for network in networks:
			if child in network["wires"]:
				in_a_network = true
				break
		
		if !in_a_network:
			child.queue_free()


func update_debug_info() -> void:
	for child in get_children():
		if !child.get_node_or_null("WiringComponent"):
			continue
		
		var device = child.get_node("WiringComponent")
		device.get_node("Label3D2").text = str(get_neighbors(get_path_to(device))).replace(",", "\n")
		device.get_node("Label3D3").text = str(device)


## Broken. Do not use.
func fix_all_network_overlaps() -> void:
	for network in networks:
		for device in network["devices"]:
			pass
			#fix_network_overlap(network, device)
