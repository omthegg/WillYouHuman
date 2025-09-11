extends CharacterBody3D

@onready var shooting_arm:Node3D = $Model/ShootingArm

var speed:float = 6.0

func _physics_process(delta):
	if Global.scene_manager.current_level.player:
		shooting_arm.look_at(Global.scene_manager.current_level.player.global_position)
