extends Area3D

@export var line_length:float = 1.0:
	set(value):
		line_length = value
		refresh_tip()

@export var color:Color = Color.WHITE:
	set(value):
		color = value
		refresh_tip()

@export var move_vector:Vector3 = Vector3(0.0, 0.0, -1.0): ## Should be normalized
	set(value):
		move_vector = value
		refresh_tip()

@onready var mesh_instance:MeshInstance3D = $Tip/MeshInstance3D
@onready var collision_shape:CollisionShape3D = $CollisionShape3D
@onready var line:MeshInstance3D = $Line
@onready var tip:Node3D = $Tip
@onready var cursor_plane:StaticBody3D = $Tip/CursorPlane
@onready var cursor_plane_collision_shape = $Tip/CursorPlane/CollisionShape3D
@onready var cursor_plane_collision_shape2 = $Tip/CursorPlane/CollisionShape3D2
@onready var camera:Camera3D = get_viewport().get_camera_3d()
@onready var cursor:Node3D = get_node("/root/LevelEditor/3DCursor")

var grabbed:bool = false
var grab_origin:Vector3


func _ready() -> void:
	refresh_tip()


func _physics_process(_delta: float) -> void:
	if grabbed:
		if Input.is_action_just_released("left_click"):
			stop_grab()
		
		global_position = (cursor.position - grab_origin) * move_vector


func refresh_tip() -> void:
	if !mesh_instance:
		return
	if !collision_shape:
		return
	if !line:
		return
	
	var tip_pos = move_vector * (line_length + 0.15)
	tip.position = tip_pos
	collision_shape.position = tip_pos
	tip.look_at(tip.global_position + move_vector,Vector3.RIGHT)
	collision_shape.rotation = mesh_instance.global_rotation
	var vertices:PackedVector3Array = []
	vertices.push_back(Vector3.ZERO)
	vertices.push_back(tip.position)
	line.mesh = Global.create_line_mesh(vertices)
	mesh_instance.material_override.albedo_color = color
	line.material_override.albedo_color = color


func start_grab() -> void:
	grabbed = true
	cursor_plane_collision_shape.disabled = false
	cursor_plane_collision_shape2.disabled = false
	collision_shape.disabled = true
	grab_origin = cursor.position

func stop_grab() -> void:
	grabbed = false
	cursor_plane_collision_shape.disabled = true
	cursor_plane_collision_shape2.disabled = true
	collision_shape.disabled = false
