extends StaticBody3D

@onready var mover_component:Node3D = $MoverComponent
@onready var wiring_component:Area3D = $WiringComponent

@export var group_to_move:String = ""
@export var time:float = 3.0
@export var movement_vector:Vector3 = Vector3.ZERO

var started_moving:bool = false


func _physics_process(_delta: float) -> void:
	if wiring_component.powered:
		if !started_moving:
			move()


func get_objects() -> void:
	var objects:Array = []
	for node in get_tree().get_nodes_in_group(group_to_move):
		if node.get_parent() == get_parent():
			objects.append(node)
	
	mover_component.objects = objects


func move() -> void:
	get_objects()
	var tween:Tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", global_position + movement_vector, time)
