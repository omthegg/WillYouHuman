extends Spatial

var speed = 300
var velocity = Vector3()


func _physics_process(delta):
	velocity = -global_transform.basis.z * speed
	global_transform.origin += velocity * delta
	
	if global_transform.origin.distance_squared_to(Global.player.global_transform.origin) > 10000:
		queue_free()


func _on_VisibilityNotifier_camera_exited(_camera):
	queue_free()
