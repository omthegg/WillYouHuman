extends Spatial


func _physics_process(delta):
	scale -= Vector3(0.1, 0.1, 0.1) * 10 * delta
	if scale <= Vector3(0, 0, 0):
		queue_free()

