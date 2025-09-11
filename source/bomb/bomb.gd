extends RigidBody3D

@export var time:float = 5.0:
	set(value):
		time = value
		timer.wait_time = time
		timer.start()

@onready var raycast:RayCast3D = $RayCast3D
@onready var outline:MeshInstance3D = $Outline
@onready var timer:Timer = $Timer
@onready var mesh_instance:MeshInstance3D = $MeshInstance3D

var objects_near:Array = []

var shake_timer:float = 0.0

func _ready() -> void:
	if time == -1.0:
		return
	
	timer.wait_time = time
	timer.start()


func _physics_process(delta) -> void:
	shake(delta)
	
	if raycast.is_colliding():
		outline.global_position = raycast.get_collision_point() + Vector3(0.0, 0.1, 0.0)
		outline.scale = Vector3.ONE * (3.0 - (global_position.y - raycast.get_collision_point().y))/2.5
	else:
		outline.scale = Vector3.ONE * 0.1


func explode() -> void:
	for object in objects_near:
		if object.get_node_or_null("HealthComponent"):
			object.get_node("HealthComponent").damage()
	
	queue_free()


func shake(delta:float) -> void:
	shake_timer += delta
	if shake_timer >= 0.01:
		shake_timer = 0.0
		var progress:float = pow(abs(timer.time_left - timer.wait_time), 3) / 30.0
		mesh_instance.rotation_degrees.x = randf_range(-progress, progress)
		mesh_instance.rotation_degrees.y = randf_range(-progress, progress)
		mesh_instance.rotation_degrees.z = randf_range(-progress, progress)
		mesh_instance.scale = Vector3.ONE * (progress/40.0 + 1)


func _on_timer_timeout() -> void:
	explode()


func _on_range_body_entered(body) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		objects_near.append(body)


func _on_range_body_exited(body) -> void:
	if body in objects_near:
		objects_near.erase(body)
