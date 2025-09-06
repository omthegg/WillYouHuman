extends RigidBody3D

@export var time:float = 5.0

@onready var raycast:RayCast3D = $RayCast3D
@onready var outline:MeshInstance3D = $Outline
@onready var timer:Timer = $Timer

var objects_near:Array = []

func _ready() -> void:
	timer.wait_time = time
	timer.start()


func _physics_process(_delta) -> void:
	if !raycast.is_colliding():
		outline.scale = Vector3.ONE * 0.1
		return
	
	outline.global_position = raycast.get_collision_point() + Vector3(0.0, 0.1, 0.0)
	outline.scale = Vector3.ONE * (3.0 - (global_position.y - raycast.get_collision_point().y))/2.5


func explode() -> void:
	for object in objects_near:
		if object.get_node_or_null("HealthComponent"):
			object.get_node("HealthComponent").damage()
	
	queue_free()


func _on_timer_timeout() -> void:
	explode()


func _on_range_body_entered(body) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		objects_near.append(body)


func _on_range_body_exited(body) -> void:
	if body in objects_near:
		objects_near.erase(body)
