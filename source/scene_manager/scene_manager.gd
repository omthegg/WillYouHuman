extends Node3D

var packed_level_editor:PackedScene = preload("res://source/level_editor/level_editor.tscn")
var packed_current_level:PackedScene
var current_level:Node3D

func _ready() -> void:
	Global.scene_manager = self
	#$MenuCanvasLayer/ColorRect.material.set_shader_parameter("LineColor", Color.DARK_ORANGE)


func play_level(packed_level:PackedScene) -> void:
	packed_current_level = packed_level
	var level:Node3D = packed_level.instantiate()
	current_level = level
	add_child(level)
	get_level_ready(level)
	level.process_mode = Node.PROCESS_MODE_PAUSABLE


func get_level_ready(level:Node3D) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for child in level.get_children():
		Global.remove_editor_highlight(child)
		Global.remove_gizmos(child)
		
		disable_editor_related_collision(child)
		if child is CSGPrimitive3D:
			if child.collision:
				child.set_collision_layer_value(4, true)
				child.set_collision_mask_value(4, true)
		
		if child is PhysicsBody3D:
			child.set_collision_layer_value(4, true)
			child.set_collision_mask_value(4, true)
		
		#if child.name == "Player":


func disable_editor_related_collision(node:Node3D) -> void:
	if node.has_method("set_collision_layer_value"):
		node.set_collision_layer_value(1, false)
		node.set_collision_layer_value(2, false)
		node.set_collision_layer_value(3, false)
		node.set_collision_mask_value(1, false)
		node.set_collision_mask_value(2, false)
		node.set_collision_mask_value(3, false)
