extends CharacterBody3D

@onready var shooting_arm:Node3D = $Model/ShootingArm
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var shooting_raycast:RayCast3D = $Model/ShootingArm/Node3D/Revolver/HitscanComponent/RayCast3D

var speed:float = 6.0

func _ready() -> void:
	shooting_raycast.global_position = $Model/Head.global_position


func _physics_process(delta:float) -> void:
	animation_player.play("walk")
	var player:CharacterBody3D = Global.scene_manager.current_level.get_node_or_null("Player")
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		shooting_arm.look_at(player.head.global_position + Vector3(0, -0.3, 0.0))
		shooting_raycast.look_at(player.head.global_position)
