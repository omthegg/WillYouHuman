extends Area3D

@export var move_vector:Vector3 = Vector3.ZERO:
	set(value):
		move_vector = value
		if cursor_plane:
			cursor_plane.look_at(move_vector)

@export var toggles_top_level:bool = true

@onready var collision_shape:CollisionShape3D = $CollisionShape3D
@onready var cursor_plane_collision_shape1:CollisionShape3D = $CursorPlane/CollisionShape3D
@onready var cursor_plane_collision_shape2:CollisionShape3D = $CursorPlane/CollisionShape3D2
@onready var cursor_plane:StaticBody3D = $CursorPlane
@onready var cursor:Node3D = get_node_or_null("/root/LevelEditor/3DCursor")

var grabbed:bool = false
var grab_origin:Vector3
var origin:Vector3

func _input(_event):
	if Input.is_action_just_released("left_click"):
		if grabbed:
			stop_grab()

func _physics_process(_delta: float) -> void:
	if grabbed:
		get_parent().global_position = origin + (cursor.position - grab_origin) * abs(move_vector)


func start_grab() -> void:
	grabbed = true
	cursor_plane_collision_shape1.disabled = false
	cursor_plane_collision_shape2.disabled = false
	collision_shape.disabled = true
	grab_origin = cursor.position
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
