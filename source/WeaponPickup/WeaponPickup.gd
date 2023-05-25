extends Spatial

export var weapon:int = 5
# 0 : nothing
# 1 : revolver
# 2 : shotgun
# 3 : nailgun
# 4 : rocket launcher
# 5 : super nailgun

onready var weapons = [$wyh_revolver, $wyh_shotgun, $wyh_nailgun, $wyh_rocketlauncher, $wyh_supernailgun]


func _ready():
	$Area.set_as_toplevel(true)
	
	for i in weapons:
		i.hide()
	
	if weapon != 0:
		weapons[weapon - 1].show()
		$AnimationPlayer.play("spin")


func _process(_delta):
	$Area.global_transform.origin = global_transform.origin


func _on_AnimationPlayer_animation_finished(_anim_name):
	$AnimationPlayer.play("spin")


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if weapon != 0:
			Global.unlock_weapon(weapon)
			hide()
			weapon = 0
