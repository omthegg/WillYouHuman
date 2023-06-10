extends Node

var player_moved = false
var spikes_enabled = true

var previous_player_position:Vector3
var player_destination:Vector3


var timer = 0.0

var prediction_object = Spatial.new()
var raycast_up = RayCast.new()
var raycast_down = RayCast.new()
var raycast_front = RayCast.new()
var raycast_back = RayCast.new()
var raycast_left = RayCast.new()
var raycast_right = RayCast.new()

var prediction_object_velocity = Vector3(0, 0, 0)
var prediction_preview = MeshInstance.new()

func _ready():
	yield(get_tree().get_root(), "ready")
	
	add_child(prediction_object)
	
	raycast_up.cast_to = Vector3.UP * 2
	raycast_down.cast_to = Vector3.DOWN * 2
	raycast_front.cast_to = Vector3.FORWARD * 2
	raycast_back.cast_to = Vector3.BACK * 2
	raycast_left.cast_to = Vector3.LEFT * 2
	raycast_right.cast_to = Vector3.RIGHT * 2
	
	raycast_up.enabled = true
	raycast_down.enabled = true
	raycast_front.enabled = true
	raycast_back.enabled = true
	raycast_left.enabled = true
	raycast_right.enabled = true
	
	prediction_object.add_child(raycast_up)
	prediction_object.add_child(raycast_down)
	prediction_object.add_child(raycast_front)
	prediction_object.add_child(raycast_back)
	prediction_object.add_child(raycast_left)
	prediction_object.add_child(raycast_right)
	
	get_tree().get_root().add_child(prediction_preview)
	prediction_preview.mesh = CylinderMesh.new()
	prediction_preview.material_override = SpatialMaterial.new()
	prediction_preview.material_override.albedo_color = Color.cyan


func _physics_process(delta):
	if !Global.editing_level and Global.map and Global.player:
		timer += delta
		if timer >= 1:
			previous_player_position = Global.player.global_transform.origin
	
#	prediction_object_velocity = Global.player.move_vel
#	prediction_object.global_transform.origin = Global.player.global_transform.origin
#	var prediction_steps = 0
#	var previous_position = Global.player.global_transform.origin
#	while prediction_steps < 5:
#
#		if prediction_object_velocity.x > 0:
#			if !raycast_right.is_colliding():
#				prediction_object.global_transform.origin.x += prediction_object_velocity.x / Engine.get_frames_per_second()
#
#		if prediction_object_velocity.x < 0:
#			if !raycast_left.is_colliding():
#				prediction_object.global_transform.origin.x += prediction_object_velocity.x / Engine.get_frames_per_second()
#
#		if prediction_object_velocity.z > 0:
#			if !raycast_front.is_colliding():
#				prediction_object.global_transform.origin.z += prediction_object_velocity.x / Engine.get_frames_per_second()
#
#		if prediction_object_velocity.z < 0:
#			if !raycast_back.is_colliding():
#				prediction_object.global_transform.origin.z += prediction_object_velocity.x / Engine.get_frames_per_second()
#
#		#if prediction_object_velocity.y > 0:
#		#	if !raycast_right.is_colliding():
#		#		prediction_object.global_transform.origin.x += prediction_object_velocity.x
#
#		if !raycast_down.is_colliding():
#			prediction_object.global_transform.origin.y -= Global.player.gravity * prediction_steps / Engine.get_frames_per_second()
#
#		#print(raycast_down.is_colliding())
#
#		var line = Line3D.new()
#		line.line_begin = previous_position
#		line.line_end = prediction_object.global_transform.origin
#
#		previous_position = prediction_object.global_transform.origin
#
#		prediction_steps += 1
#
#	#print(prediction_object.global_transform.origin)
#	prediction_preview.global_transform.origin = prediction_object.global_transform.origin


func predict_player_position():
	return player_destination
