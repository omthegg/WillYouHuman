extends CharacterBody3D

@onready var shooting_arm:Node3D = $Model/ShootingArm
@onready var animation_player:AnimationPlayer = $AnimationPlayer

var speed:float = 6.0

func _physics_process(delta):
	animation_player.play("walk")
	var player:CharacterBody3D = Global.scene_manager.current_level.get_node_or_null("Player")
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		shooting_arm.look_at(player.head.global_position + Vector3(0, -0.3, 0.0))
