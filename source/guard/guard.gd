extends CharacterBody3D

@onready var shooting_arm:Node3D = $Model/ShootingArm
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var shooting_raycast:Node3D = $Model/ShootingArm/Node3D/Revolver/HitscanComponent/RayCast3D
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D
@onready var move_timer:Timer = $MoveTimer
@onready var random_timer:Timer = $RandomTimer

var player:CharacterBody3D

var speed:float = 5.0

func _ready() -> void:
	#shooting_raycast = $Model/ShootingArm/Node3D/Revolver/HitscanComponent/RayCast3D
	#print(shooting_raycast)
	shooting_raycast.global_position = $Model/Head.global_position
	
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 1.0
	
	random_timer.wait_time = randf_range(0.0, 1.0)
	random_timer.start()


func _physics_process(delta:float) -> void:
	player = Global.scene_manager.current_level.player
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		shooting_arm.look_at(player.head.global_position + Vector3(0, -0.3, 0.0))
		shooting_raycast.look_at(player.head.global_position)
		
		move_to_path()
	
	if (velocity * Vector3(1.0, 0.0, 1.0)).length() > 1.0:
		animation_player.play("walk")
	else:
		animation_player.play("stand")


func find_path_to_player(player:CharacterBody3D) -> void:
	await get_tree().physics_frame
	navigation_agent.set_target_position(player.global_position + 
	Vector3(randf_range(-6.0, 6.0), 0.0, randf_range(-6.0, 6.0)))


func move_to_path() -> void:
	var next_path_position:Vector3 = navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * speed
	if navigation_agent.is_target_reached():
		velocity = Vector3.ZERO
	
	move_and_slide()


func _on_move_timer_timeout() -> void:
	find_path_to_player(player)
	move_timer.start()


func _on_random_timer_timeout() -> void:
	move_timer.start()
