extends Node3D

signal finished_moving

var objects:Array = []

var last_global_position:Vector3

func _ready() -> void:
	last_global_position = global_position


func _physics_process(_delta: float) -> void:
	for object in objects:
		object.global_position += last_global_position - global_position
	
	last_global_position = global_position


func move(movement_vector:Vector3, time:float) -> void:
	var tween:Tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", global_position + movement_vector, time)
	tween.connect("finished", Callable(self, "tween_finished"))


func tween_finished() -> void:
	emit_signal("finished_moving")
