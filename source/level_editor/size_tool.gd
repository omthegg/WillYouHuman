extends Node3D

@export var move_vector:Vector3 = Vector3.ZERO

@onready var dragging_component:Area3D = $DraggingComponent

var previous_global_position:Vector3 = Vector3.ZERO

func _ready():
	dragging_component.move_vector = move_vector
	previous_global_position = global_position
