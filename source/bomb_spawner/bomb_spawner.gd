extends Node3D

@export var time:float = 5.0

@onready var bomb_mesh_instance:MeshInstance3D = $BombMeshInstance
@onready var outline_mesh_instance:MeshInstance3D = $Outline
@onready var timer:Timer = $Timer

func _ready() -> void:
	timer.wait_time = time
	timer.start()


func _physics_process(_delta):
	bomb_mesh_instance.scale = Vector3.ONE * (time - timer.time_left) / time + Vector3(0.01, 0.01, 0.01)


func spawn_bomb() -> void:
	pass


func _on_timer_timeout():
	timer.start()
