extends StaticBody3D

@export var time:float = 5.0
@export var bomb_time:float = 5.0

@onready var bomb_mesh_instance:MeshInstance3D = $BombMeshInstance
@onready var outline_mesh_instance:MeshInstance3D = $Outline
@onready var timer:Timer = $Timer

var bomb_scene:PackedScene = preload("res://source/bomb/bomb.tscn")

func _ready() -> void:
	if time <= 0.0:
		time = 1.0
	
	timer.wait_time = time
	timer.start()
	
	#if !Global.is_in_level_editor(self):
	#	$CollisionShape3D.disabled = true



func _physics_process(_delta):
	bomb_mesh_instance.scale = Vector3.ONE * (time - timer.time_left) / time + Vector3(0.01, 0.01, 0.01)


func spawn_bomb() -> void:
	var bomb_instance:RigidBody3D = bomb_scene.instantiate()
	Global.scene_manager.current_level.add_child(bomb_instance)
	bomb_instance.global_position = global_position
	bomb_instance.time = bomb_time


func _on_timer_timeout():
	spawn_bomb()
	timer.start()
