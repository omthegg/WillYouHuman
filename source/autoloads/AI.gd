extends Node

var player_moved = false
var spikes_enabled = true

var previous_player_position:Vector3
var player_destination:Vector3


var timer = 0.0


func _physics_process(delta):
	if !Global.editing_level and Global.map and Global.player:
		timer += delta
		if timer >= 1:
			previous_player_position = Global.player.global_transform.origin
	


func predict_player_position():
	return player_destination
