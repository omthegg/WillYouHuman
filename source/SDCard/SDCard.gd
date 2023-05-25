extends Spatial


func _ready():
	$AnimationPlayer.play("Spin")



func _on_AnimationPlayer_animation_finished(_anim_name):
	$AnimationPlayer.play("Spin")
