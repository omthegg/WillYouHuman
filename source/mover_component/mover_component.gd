extends Node3D

var objects:Array = []

var last_global_position:Vector3

func _ready() -> void:
	last_global_position = global_position


func _physics_process(_delta: float) -> void:
	for object in objects:
		object.global_position += last_global_position - global_position
	
	last_global_position = global_position
