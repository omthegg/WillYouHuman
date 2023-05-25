extends Spatial


#var discarded_groups = ['Player', 'PlayerClone', 'Spike']


func _ready():
	$MeshInstance.hide()
	$MeshInstance.translation = Vector3(0, -0.01, 0)
	$MeshInstance.mesh = $MeshInstance.mesh.duplicate()
	$MeshInstance.mesh.height = 0.001
	
	#global_transform.origin.x += rand_range(-2, 2)
	#global_transform.origin.z += rand_range(-2, 2)


func raise():
	$MeshInstance.show()
	$AnimationPlayer.play("raise")
	$Timer.start()
	yield($Timer, "timeout")
	$AnimationPlayer.play_backwards("raise")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	


func damage(_amount:int=1):
	die()

func die():
	queue_free()


func _on_Area_body_entered(body):
	if body is CSGShape:
		queue_free()


func _on_Area_area_entered(area):
	if area.is_in_group("Spike"):
		if get_instance_id() > area.get_parent().get_instance_id():
			queue_free()


func _on_DamageBox_body_entered(body):
	if visible:
		if body.is_in_group("Player"):
			body.damage()
