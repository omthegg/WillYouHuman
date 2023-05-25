extends Spatial

var used = false

func _ready():
	$AnimationPlayer.play("hover")


func _physics_process(_delta):
	if Global.player:
		var lookat = Global.player.global_transform.origin
		lookat.y = global_transform.origin.y
		$Sprite3D.look_at(lookat, Vector3.UP)
		$Sprite3D.rotation_degrees.x = 70


func _on_AnimationPlayer_animation_finished(anim_name):
	if $Sprite3D.visible:
		$AnimationPlayer.play("hover")
	
	if anim_name == 'refresh':
		if used:
			$Area/CollisionShape.set_deferred('disabled', true)
			$Sprite3D.hide()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.speed_multiplier = 1.4
		body.SpeedBoostTimer.start()
		$AnimationPlayer.play_backwards("refresh")
		$RefreshTimer.start()
		used = true


func _on_RefreshTimer_timeout():
	$Area/CollisionShape.set_deferred('disabled', false)
	$AnimationPlayer.play("refresh")
	used = false
