extends StaticBody3D

@onready var mover_component:Node3D = $MoverComponent
@onready var wiring_component:Area3D = $WiringComponent

@export var group_to_move:String = ""
@export var time:float = 3.0
@export var movement_vector:Vector3 = Vector3.ZERO
@export var one_time_activation:bool = true

var started_moving:bool = false


func _physics_process(_delta: float) -> void:
	if wiring_component.powered:
		if !started_moving:
			move()
			started_moving = true


func get_objects() -> void:
	var objects:Array = []
	for node in get_tree().get_nodes_in_group(group_to_move):
		print(node.name)
		if node.get_parent() == get_parent():
			objects.append(node)
	
	print(objects)
	mover_component.objects = objects


func move() -> void:
	get_objects()
	mover_component.move(movement_vector, time)


func _on_mover_component_finished_moving():
	if !one_time_activation:
		started_moving = false
