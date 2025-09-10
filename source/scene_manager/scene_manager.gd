extends Node3D

@onready var menu_canvas_layer:CanvasLayer = $MenuCanvasLayer
@onready var hud_canvas_layer:CanvasLayer = $HUDCanvasLayer
@onready var pause_menu:Control = $MenuCanvasLayer/SubViewportContainer/SubViewport/PauseMenu
@onready var death_screen:Control = $HUDCanvasLayer/DeathScreen
@onready var networks_text_edit:TextEdit = $HUDCanvasLayer/NetworksTextEdit

var wire:PackedScene = preload("res://source/wire/wire.tscn")

var packed_level_editor:PackedScene = preload("res://source/level_editor/level_editor.tscn")
var packed_current_level:PackedScene
var current_level:Node3D
var level_editor:Node3D

func _ready() -> void:
	Global.scene_manager = self
	set_game_paused(true)
	play_level(packed_level_editor)


func _physics_process(_delta) -> void:
	if current_level and is_instance_valid(current_level):
		current_level.update_debug_info()
		networks_text_edit.text = str(current_level.networks).replace(", ", "\n").replace("[", "").replace("]", "")


func _input(event) -> void:
	if Input.is_action_just_pressed("pause"):
		if !current_level and !level_editor:
			return
		set_game_paused(!get_tree().paused)
	
	if Input.is_action_just_pressed("restart"):
		restart_current_level()


func play_level(packed_level:PackedScene) -> void:
	packed_current_level = packed_level
	var child:Node3D = packed_level.instantiate()
	add_child(child)
	
	if packed_level == packed_level_editor:
		level_editor = child
		hud_canvas_layer.hide()
		return
	
	hud_canvas_layer.show()
	current_level = child
	get_level_ready(child)
	child.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	death_screen.hide()
	
	if level_editor:
		pause_menu.editor_button.show()
	else:
		pause_menu.editor_button.hide()


func get_level_ready(level:Node3D) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for child in level.get_children():
		if !(child is Node3D):
			continue
		
		Global.remove_editor_highlight(child)
		Global.remove_gizmos(child)
		
		disable_editor_related_collision(child)
		
		if child.is_in_group("no_collision"):
			continue
		
		if child.get("collision"):
			if child.collision:
				child.set_collision_layer_value(4, true)
				child.set_collision_mask_value(4, true)
		
		if child is PhysicsBody3D:
			child.set_collision_layer_value(4, true)
			child.set_collision_mask_value(4, true)
		
		if child.is_in_group("Player"):
			child.camera.current = true


func disable_editor_related_collision(node:Node3D) -> void:
	if node.has_method("set_collision_layer_value"):
		node.set_collision_layer_value(1, false)
		node.set_collision_layer_value(2, false)
		node.set_collision_layer_value(3, false)
		node.set_collision_mask_value(1, false)
		node.set_collision_mask_value(2, false)
		node.set_collision_mask_value(3, false)


func set_game_paused(paused:bool = true) -> void:
	if paused == menu_canvas_layer.visible:
		return
	
	menu_canvas_layer.visible = paused
	get_tree().paused = paused
	if !current_level:
		return
	
	hud_canvas_layer.visible = !paused
	if paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func return_to_level_editor() -> void:
	current_level.queue_free()
	pause_menu.editor_button.hide()
	level_editor.show()
	level_editor.ui.show()
	set_game_paused(false)
	hud_canvas_layer.hide()
	level_editor.process_mode = Node.PROCESS_MODE_INHERIT
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func restart_current_level() -> void:
	if !(current_level and is_instance_valid(current_level)):
		return
	
	current_level.queue_free()
	play_level(packed_current_level)
