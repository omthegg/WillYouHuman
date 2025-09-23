extends CharacterBody3D

@onready var shooting_arm:Node3D = $Model/ShootingArm
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var shooting_raycast:Node3D = $Model/ShootingArm/Node3D/Revolver/HitscanComponent/RayCast3D
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D
@onready var move_timer:Timer = $MoveTimer
@onready var random_timer:Timer = $RandomTimer
@onready var shoot_timer:Timer = $ShootTimer
@onready var target_timer:Timer = $TargetTimer
@onready var revolver_hitscan_component:Node3D = $Model/ShootingArm/Node3D/Revolver/HitscanComponent
@onready var laser:MeshInstance3D = $Model/ShootingArm/Node3D/Laser
@onready var player_detector:RayCast3D = $PlayerDetector

var player:CharacterBody3D

var speed:float = 8.0

var targeting:bool = false
var shooting:bool = false

var active:bool = false

var target_mesh_instance:MeshInstance3D = MeshInstance3D.new()

func _ready() -> void:
	shooting_raycast.reparent(self)
	#shooting_raycast = $Model/ShootingArm/Node3D/Revolver/HitscanComponent/RayCast3D
	#print(shooting_raycast)
	shooting_raycast.global_position = $Model/Head.global_position
	
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0
	
	shoot_timer.wait_time = 0.5
	target_timer.wait_time = 0.5
	
	#random_timer.wait_time = randf_range(0.0, 1.0)
	#random_timer.start()
	#move_timer.start()
	find_path_to_player()
	
	add_child(target_mesh_instance, true)
	target_mesh_instance.mesh = QuadMesh.new()
	target_mesh_instance.mesh.size = Vector2(0.5, 0.5)
	target_mesh_instance.material_override = StandardMaterial3D.new()
	target_mesh_instance.material_override.billboard_mode = 1
	target_mesh_instance.material_override.shading_mode = 0
	target_mesh_instance.top_level = true


func _physics_process(_delta:float) -> void:
	player = Global.scene_manager.current_level.player
	if !player:
		return
	
	player_detector.look_at(player.global_position)
	if player_detector.get_collider() == player:
		active = true
	
	if !active:
		return
	
	if !shooting:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		shooting_arm.look_at(player.head.global_position + Vector3(0, -0.3, 0.0))
		shooting_raycast.look_at(player.head.global_position)
		
		
		move_to_path()
		
		#move_to_path()
	
	if (velocity * Vector3(1.0, 0.0, 1.0)).length() > 1.0:
		animation_player.play("walk")
	else:
		animation_player.play("stand")
	
	move_and_slide()


func find_path_to_player() -> void:
	if Global.is_in_level_editor(self):
		return
	if !is_instance_valid(player):
		return
	
	await get_tree().physics_frame
	var target_position:Vector3 = player.global_position + Vector3(randi_range(-6, 6), 0.0, randi_range(-6, 6))
	navigation_agent.set_target_position(target_position)


func move_to_path() -> void:
	if navigation_agent.is_navigation_finished():
		if !targeting and !shooting:
			target()
		velocity = Vector3.ZERO
		return
	
	var next_path_position:Vector3 = navigation_agent.get_next_path_position()
	target_mesh_instance.global_position = next_path_position
	velocity = global_position.direction_to(next_path_position) * speed


func target() -> void:
	laser.show()
	target_timer.start()
	targeting = true


func shoot() -> void:
	shooting_arm.look_at(Global.scene_manager.future_player_position)
	shooting_raycast.look_at(Global.scene_manager.future_player_position)
	shoot_timer.start()
	shooting = true


func _on_move_timer_timeout() -> void:
	find_path_to_player()


func _on_random_timer_timeout() -> void:
	move_timer.start()


func _on_shoot_timer_timeout() -> void:
	revolver_hitscan_component.shoot()
	laser.hide()
	#move_timer.start()
	find_path_to_player()
	shooting = false


func _on_target_timer_timeout() -> void:
	targeting = false
	shoot()
