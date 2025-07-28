extends Node3D

@export var move_vector:Vector3 = Vector3.ZERO

@onready var dragging_component:Area3D = $DraggingComponent

var previous_global_position:Vector3 = Vector3.ZERO

func _ready():
	dragging_component.move_vector = move_vector
	previous_global_position = global_position

func _physics_process(_delta):
	if top_level:
		if global_position != previous_global_position:
			var position_difference:Vector3 = global_position - previous_global_position
			get_parent().global_position += position_difference/2
			get_parent().size += position_difference
	
	previous_global_position = global_position
