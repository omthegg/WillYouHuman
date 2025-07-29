extends Node3D

@export var move_vector:Vector3 = Vector3.ZERO

@onready var dragging_component:Area3D = $DraggingComponent

var previous_global_position:Vector3 = Vector3.ZERO

func _ready():
	dragging_component.move_vector = move_vector
	previous_global_position = global_position

#func _physics_process(_delta):
	#if top_level:
		#if global_position != previous_global_position:
			#var position_difference:Vector3 = global_position - previous_global_position
			#var box:CSGBox3D = get_parent()
			#box.global_position += position_difference/2
			#box.size += position_difference
			#if box.size.x == 0 or box.size.y == 0 or box.size.z == 0:
				#box.global_position += position_difference/2
				#box.size += abs(position_difference)
			#
			#box.flip_faces = box.size.x < 0 or box.size.y < 0 or box.size.z < 0
	#
	#previous_global_position = global_position
