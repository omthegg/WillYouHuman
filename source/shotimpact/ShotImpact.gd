extends Spatial

var emitted = false

func set_color(color:Color):
	$Particles.material_override.albedo_color = color


func emit():
	# This is to prevent an error
	if global_transform.origin.distance_squared_to(Global.player.camera.global_transform.origin) > 0:
		look_at(Global.player.camera.global_transform.origin, Vector3.UP)
	
	$Particles.emitting = true
	emitted = true


func _process(_delta):
	if !($Particles.emitting) and emitted:
		queue_free()


func _on_VisibilityNotifier_screen_exited():
	queue_free()
