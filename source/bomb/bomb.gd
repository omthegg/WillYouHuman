extends RigidBody3D

@export var time:float = 5.0

@onready var raycast:RayCast3D = $RayCast3D
@onready var outline:MeshInstance3D = $Outline

var objects_near:Array = []

func _physics_process(_delta) -> void:
	outline.global_position = raycast.get_collision_point() + Vector3(0.0, 0.05, 0.0)
	outline.scale = Vector3.ONE * (global_position.y - raycast.get_collision_point().y)/3


func explode() -> void:
	for object in objects_near:
		if object.get_node_or_null("HealthComponent"):
			object.get_node("HealthComponent").damage()


func _on_timer_timeout() -> void:
	explode()


func _on_range_body_entered(body) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		objects_near.append(body)


func _on_range_body_exited(body) -> void:
	if body in objects_near:
		objects_near.erase(body)
