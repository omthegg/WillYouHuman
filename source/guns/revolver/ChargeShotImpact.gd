extends Spatial

var size = 1.0
var damage

var bodies = []

func _ready():
	#$MeshInstance.scale = Vector3(size, size, size)
	#$MeshInstance.mesh
	pass

func blast():
	$Area/CollisionShape.scale = Vector3(size, size, size)
	$Tween.interpolate_property($MeshInstance, "scale", $MeshInstance.scale, Vector3(size, size, size), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$AnimationPlayer.play("blast")
	Global.player.shake_camera(0.5, 20)
	$AudioStreamPlayer3D.play()
	yield(get_tree(), "physics_frame")
	print(damage)
	#for i in $Area.get_overlapping_bodies():
		#var collider = Global.player.revolver_raycast.get_collider()
	#	if i.is_in_group("Enemy"):
	#		print(i)
	#		i.damage(damage)
		#elif collider.is_in_group("EnemyHitbox"):
		#	collider.get_parent().damage(secondary_charge * 6)



func _on_AnimationPlayer_animation_finished(_anim_name):
	yield($AudioStreamPlayer3D, "finished")
	queue_free()



func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		print(body)
		body.damage(damage)
