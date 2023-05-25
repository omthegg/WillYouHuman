extends Spatial

var collected = true

var smileys = []

func _ready():
	$AnimationPlayer.play("float")
	$MeshInstance.hide()
	$Timer.start()


func spawn_smileys():
	for _i in range(30):
		var smiley_instance = Global.smiley.instance()
		Global.map.Smileys.add_child(smiley_instance)
		smiley_instance.global_transform.origin = global_transform.origin
		#smiley_instance.speed *= 7
		smiley_instance.enabled = false
		smileys.append(smiley_instance)
		yield(get_tree(), "physics_frame")
	
	$EnableTimer.start()
	yield($EnableTimer, "timeout")
	
	for i in smileys:
		i.enabled = true
		yield($EnableTimer, "timeout")


func _on_AnimationPlayer_animation_finished(_anim_name):
	$AnimationPlayer.play("float")


func _on_Timer_timeout():
	$AnimationPlayer2.play("ready")
	collected = false


func _on_Area_body_entered(body):
	if !collected:
		if body.is_in_group("Player"):
			$MeshInstance.hide()
			collected = true
			spawn_smileys()
