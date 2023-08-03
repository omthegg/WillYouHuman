extends StaticBody

onready var animation_player = $AnimationPlayer
onready var sprite3d = $Sprite3D
onready var area_collisionshape = $Area/CollisionShape
onready var refresh_timer = $RefreshTimer

var used = false

func _ready():
	animation_player.play("hover")
	if !Global.editing_level:
		$CollisionShape.disabled = true


func _physics_process(_delta):
	if Global.player:
		var lookat = Global.player.global_transform.origin
		lookat.y = global_transform.origin.y
		sprite3d.look_at(lookat, Vector3.UP)
		sprite3d.rotation_degrees.x = 70


func _on_AnimationPlayer_animation_finished(anim_name):
	if sprite3d.visible:
		animation_player.play("hover")
	
	if anim_name == 'refresh':
		if used:
			area_collisionshape.set_deferred('disabled', true)
			sprite3d.hide()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.speed_multiplier = 1.4
		body.SpeedBoostTimer.start()
		animation_player.play_backwards("refresh")
		refresh_timer.start()
		used = true


func _on_RefreshTimer_timeout():
	area_collisionshape.set_deferred('disabled', false)
	animation_player.play("refresh")
	used = false
