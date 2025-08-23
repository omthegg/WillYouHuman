extends Area3D

@export var auto_rotate_plane:bool = true
@export var move_vector:Vector3 = Vector3.ZERO:
	set(value):
		move_vector = value
		if cursor_plane and auto_rotate_plane:
			cursor_plane.look_at(move_vector)

@export var toggles_top_level:bool = true
@export var two_dimensional:bool = false

@onready var collision_shape:CollisionShape3D = $CollisionShape3D
@onready var cursor_plane_collision_shape1:CollisionShape3D = $CursorPlane/CollisionShape3D
@onready var cursor_plane_collision_shape2:CollisionShape3D = $CursorPlane/CollisionShape3D2
@onready var cursor_plane:StaticBody3D = $CursorPlane
@onready var editor:Node3D

var grabbed:bool = false
var grab_origin:Vector3
var origin:Vector3


func _input(_event) -> void:
	if Input.is_action_just_released("left_click"):
		if grabbed:
			stop_grab()

func _physics_process(_delta: float) -> void:
	editor = Global.scene_manager.level_editor
	if grabbed:
		if two_dimensional:
			get_parent().global_position = origin + (editor.dragging_cursor.position - grab_origin)
		else:
			get_parent().global_position = origin + (editor.dragging_cursor.position - grab_origin) * abs(move_vector)


func start_grab() -> void:
	grabbed = true
	cursor_plane_collision_shape1.disabled = false
	cursor_plane_collision_shape2.disabled = false
	collision_shape.disabled = true
	grab_origin = editor.dragging_cursor.position
	origin = get_parent().global_position
	if toggles_top_level:
		get_parent().top_level = true


func stop_grab() -> void:
	grabbed = false
	cursor_plane_collision_shape1.disabled = true
	cursor_plane_collision_shape2.disabled = true
	collision_shape.disabled = false
	if toggles_top_level:
		get_parent().top_level = false
