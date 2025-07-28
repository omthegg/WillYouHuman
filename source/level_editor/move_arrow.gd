extends Node3D

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
@onready var line:MeshInstance3D = $Line
@onready var tip:Node3D = $Tip
@onready var dragging_component:Area3D = $DraggingComponent

var previous_global_position:Vector3 = Vector3.ZERO

func _ready() -> void:
	refresh_tip()
	previous_global_position = global_position


func refresh_tip() -> void:
	if !mesh_instance:
		return
	if !dragging_component:
		return
	if !line:
		return
	
	var tip_pos = move_vector * (line_length + 0.15)
	tip.position = tip_pos
	dragging_component.position = tip_pos
	tip.look_at(tip.global_position + move_vector,Vector3.RIGHT)
	dragging_component.move_vector = move_vector
	#collision_shape.rotation = mesh_instance.global_rotation
	var vertices:PackedVector3Array = []
	vertices.push_back(Vector3.ZERO)
	vertices.push_back(tip.position)
	line.mesh = Global.create_line_mesh(vertices)
	mesh_instance.material_override.albedo_color = color
	line.material_override.albedo_color = color


func _physics_process(_delta):
	if top_level:
		if global_position != previous_global_position:
			var position_difference:Vector3 = global_position - previous_global_position
			get_parent().global_position += position_difference
	
	previous_global_position = global_position
