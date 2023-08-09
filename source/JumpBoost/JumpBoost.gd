extends StaticBody

export var jump_multiplier:int = 3

var used = false

func _ready():
	if !Global.editing_level:
		$CollisionShape.disabled = true

func _on_Area_body_entered(body):
	if !used:
		if body.is_in_group("Player"):# and Input.is_action_pressed("jump"):
			#if abs(body.gravity_vec.y) == body.gravity_vec.y:
			#Input.action_press("jump")
			body.used_jump_boost = true
			body.snap = Vector3.ZERO
			body.gravity_vec.y = body.jump * jump_multiplier
			body.jumps = 1
			body.get_node("WallrunTimer").start()
			used = true
			$RefreshTimer.start()
			$AnimationPlayer.play_backwards("refresh")
			
			$Timer.start()
			yield($Timer, "timeout")
			body.used_jump_boost = false


func _on_RefreshTimer_timeout():
	used = false
	$Sprite3D.show()
	$AnimationPlayer.play("refresh")


func _on_AnimationPlayer_animation_finished(_anim_name):
	if used:
		$Sprite3D.hide()
