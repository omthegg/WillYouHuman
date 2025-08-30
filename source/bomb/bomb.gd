extends RigidBody3D

@export var time:float = 5.0

@onready var raycast:RayCast3D = $RayCast3D
@onready var outline:MeshInstance3D = $Outline

var objects_near:Array = []

func _physics_process(_delta) -> void:
	outline.global_position = raycast.get_collision_point() + Vector3(0.0, 0.05, 0.0)
	outline.scale = Vector3.ONE * (global_position.y - raycast.get_collision_point().y)


func explode() -> void:
	pass


func _on_timer_timeout() -> void:
	explode()


func _on_range_body_entered(body) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		objects_near.append(body)


func _on_range_body_exited(body) -> void:
	if body in objects_near:
		objects_near.erase(body)
