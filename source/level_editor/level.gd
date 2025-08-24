extends Node3D

class Network:
	var powered:bool = false
	var devices:Array = []

# When connecting two devices together, first create a new network
# If the object with updated wiring is in two networks at the same time,
# merge the two networks
