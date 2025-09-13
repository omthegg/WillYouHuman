extends CharacterBody3D

@onready var shooting_arm:Node3D = $Model/ShootingArm
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var shooting_raycast:Node3D = $Model/ShootingArm/Node3D/Revolver/HitscanComponent/RayCast3D
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D

var speed:float = 6.0

func _ready() -> void:
	#shooting_raycast = $Model/ShootingArm/Node3D/Revolver/HitscanComponent/RayCast3D
	#print(shooting_raycast)
	shooting_raycast.global_position = $Model/Head.global_position
	
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 1.0


func _physics_process(delta:float) -> void:
	animation_player.play("walk")
	var player:CharacterBody3D = Global.scene_manager.current_level.player
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		shooting_arm.look_at(player.head.global_position + Vector3(0, -0.3, 0.0))
		shooting_raycast.look_at(player.head.global_position)
		
		find_path_to_player(player)
		
		move_to_path()


func find_path_to_player(player:CharacterBody3D) -> void:
	await get_tree().physics_frame
	navigation_agent.target_position = player.global_position


func move_to_path() -> void:
	var next_path_position:Vector3 = navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * speed
	move_and_slide()
