extends KinematicBody

var wallrun_speed = 31
var normal_speed = 25
var speed_multiplier = 1
onready var speed = normal_speed
const ACCEL_DEFAULT = 20
const ACCEL_AIR = 20
onready var accel = ACCEL_DEFAULT
var normal_gravity = 40
var wallrun_gravity = 7
var gravity = normal_gravity
var normal_jump = 15
var wall_jump = 15#2
onready var jump = normal_jump

var can_wallrun = false
var jumps = 2

var cam_accel = 40
#var mouse_sense = 0.15
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var bounce = Vector3()

var moving_spatial_velocity = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var gun_camera = $Head/Camera/GunCamera
onready var thirdperson_camera = $Head/Camera/SpringArm/ThirdPersonCamera
onready var arms = $Head/Camera/GunCamera/PlayerArms
onready var model_skeleton = $PlayerModel/Armature/Skeleton
onready var model = $PlayerModel 

onready var head_ik_position = $Head/Camera/HeadIKPosition

onready var revolver_raycast = $Head/Camera/RevolverRaycast
onready var shotgun_raycasts = $Head/Camera/ShotgunRaycasts
onready var nailgun_raycast = $Head/Camera/NailgunRaycast
onready var nailgun_projectile_position = $Head/Camera/NailgunProjectilePosition

onready var SpeedBoostTimer = $SpeedBoostTimer
onready var speed_boost_bar = $HUD/SpeedBoostBar
onready var wallrun_bar = $HUD/Wallrunbar

onready var viewmodel_sprite = $Head/Camera/ViewModelSprite
onready var viewmodel_wall_detector = $Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition/ViewModelWallDetector


onready var revolver = $Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition/Revolver
onready var shotgun = $Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition/Shotgun
onready var nailgun = $Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition/Nailgun
onready var rocketlauncher = $Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition/RocketLauncher
onready var supernailgun = $Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition/SuperNailgun

onready var shooting_animation = $Head/Camera/GunCamera/ShootingAnimation

onready var revolver_crosshair = $HUD/PistolCrosshair
onready var shotgun_crosshair = $HUD/ShotgunCrosshair
onready var nailgun_crosshair = $HUD/NailgunCrosshair
onready var rocketlauncher_crosshair = $HUD/RocketLauncherCrosshair

onready var ground_impact_tween = $Head/Camera/GunCamera/GroundImpactTween

var touched_ground = false

var f_input = 0
var h_input = 0

var prev_f_input = 0
var prev_h_input = 0

var prev_direction:Vector3

var current_clone:KinematicBody

var move_vel:Vector3


var clone_timer = 0.0


var health = 3
var can_control = true


var normal_collision_shape = preload("res://source/player/PlayerCollisionShape.tres")
var death_collision_shape = preload("res://source/player/PlayerDeathCollisionShape.tres")



var input = 0

var wallrun_charge = 100 # Drains when you wallrun, refills when you're on the ground
var on_wall = false

var used_jump_boost = false


var can_shoot = true


enum Weapons {
	WEAPON_EMPTY = 0,
	WEAPON_REVOLVER = 1,
	WEAPON_SHOTGUN = 2,
	WEAPON_NAILGUN = 3,
	WEAPON_ROCKETLAUNCHER = 4,
	WEAPON_SUPERNAILGUN = 5
}

onready var weapon_lookup = [revolver, shotgun, nailgun, rocketlauncher, supernailgun]

var selected_weapon = 5
var previous_weapon = 5


# Class for storing hand positions for weapons
class weapon_hands_translation:
	var left_hand_position:Vector3
	var right_hand_position:Vector3
	var viewmodel_z_position:float


var revolver_hands_translation = weapon_hands_translation.new()
var shotgun_hands_translation = weapon_hands_translation.new()
var nailgun_hands_translation = weapon_hands_translation.new()
var rocketlauncher_hands_translation = weapon_hands_translation.new()
var supernailgun_hands_translation = weapon_hands_translation.new()


var hands_translations = [
	revolver_hands_translation,
	shotgun_hands_translation,
	nailgun_hands_translation,
	rocketlauncher_hands_translation,
	supernailgun_hands_translation
]


func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player_previous_pos = global_transform.origin
	Global.player = self
	AI.player_moved = false
	
	camera.fov = Settings.fov
	thirdperson_camera.fov = Settings.fov
	
	revolver_hands_translation.right_hand_position = Vector3(0.3, 2, -0.816)
	revolver_hands_translation.left_hand_position = Vector3(-0.54, 0.91, 0.00)
	revolver_hands_translation.viewmodel_z_position = 0.1
	
	shotgun_hands_translation.right_hand_position = Vector3(0.3, 1.98, -0.306)
	shotgun_hands_translation.left_hand_position = Vector3(0.37, 1.975, -0.58)
	shotgun_hands_translation.viewmodel_z_position = -0.2
	
	nailgun_hands_translation.right_hand_position = Vector3(0.3, 2.047, -0.698)
	nailgun_hands_translation.left_hand_position = Vector3(0.175, 2.004, -0.655)
	nailgun_hands_translation.viewmodel_z_position = 0.2
	
	rocketlauncher_hands_translation.right_hand_position = Vector3(0.3, 1.98, -0.6)
	rocketlauncher_hands_translation.left_hand_position = Vector3(0.37, 1.98, -0.6)
	rocketlauncher_hands_translation.viewmodel_z_position = -0.1
	
	supernailgun_hands_translation.right_hand_position = Vector3(0.3, 2.047, -0.698)
	supernailgun_hands_translation.left_hand_position = Vector3(-0.54, 0.91, 0.00)
	supernailgun_hands_translation.viewmodel_z_position = 0.2
	
	start_ik()
	
	#switch_weapons(1, 1)
	
	revolver_crosshair.set_as_toplevel(true)
	shotgun_crosshair.set_as_toplevel(true)
	nailgun_crosshair.set_as_toplevel(true)
	rocketlauncher_crosshair.set_as_toplevel(true)
	#$HUD/Crosshair.set_as_toplevel(true)
	
	wallrun_bar.set_as_toplevel(true)
	
	arms.set_skin(Collectibles.skin_iris)
	model.set_skin(Collectibles.skin_iris)
	
	if Global.unlocked_weapons.size() == 0:
		arms.hide()
	
	yield(get_tree(), "idle_frame")
	if Global.map.level_light == Global.map.LEVEL_LIGHT.BRIGHT:
		$OmniLight.hide()
	
	wallrun_bar.show()


func _input(event):
	if can_control:
		#get mouse input for camera rotation
		if event is InputEventMouseMotion:
			rotate_y(deg2rad(-event.relative.x * (Settings.mouse_sensitivity / 100.0)))
			head.rotate_x(deg2rad(-event.relative.y * (Settings.mouse_sensitivity / 100.0)))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
		if Input.is_action_just_pressed("third_person"):
			if camera.current:
				$Head/Camera/SpringArm/ThirdPersonCamera.current = true
				camera.current = false
				viewmodel_sprite.hide()
			else:
				camera.current = true
				viewmodel_sprite.show()
		
		
		if Input.is_action_just_pressed("kill"):
			die()
		
		
		# Switching weapons
		if Global.unlocked_weapons.size() > 1:
			if event is InputEventMouseButton:
				if event.is_pressed():
					if event.button_index == BUTTON_WHEEL_UP:
						previous_weapon = selected_weapon
						selected_weapon -= 1
						while !(selected_weapon in Global.unlocked_weapons):
							selected_weapon -= 1
							if selected_weapon < 1:
								selected_weapon = 5
					
					elif event.button_index == BUTTON_WHEEL_DOWN:
						previous_weapon = selected_weapon
						selected_weapon += 1
						while !(selected_weapon in Global.unlocked_weapons):
							selected_weapon += 1
							if selected_weapon > 5:
								selected_weapon = 1
					
					if selected_weapon > 5:
						selected_weapon = 1
					elif selected_weapon < 1:
						selected_weapon = 5
					
					switch_weapons(previous_weapon, selected_weapon)
			
			# Quick switching weapons
			if Input.is_action_just_pressed("1"):
				if Weapons.WEAPON_REVOLVER in Global.unlocked_weapons:
					previous_weapon = selected_weapon
					selected_weapon = 1
					switch_weapons(previous_weapon, selected_weapon)
			elif Input.is_action_just_pressed("2"):
				if Weapons.WEAPON_SHOTGUN in Global.unlocked_weapons:
					previous_weapon = selected_weapon
					selected_weapon = 2
					switch_weapons(previous_weapon, selected_weapon)
			elif Input.is_action_just_pressed("3"):
				if Weapons.WEAPON_NAILGUN in Global.unlocked_weapons:
					previous_weapon = selected_weapon
					selected_weapon = 3
					switch_weapons(previous_weapon, selected_weapon)
			elif Input.is_action_just_pressed("4"):
				if Weapons.WEAPON_ROCKETLAUNCHER in Global.unlocked_weapons:
					previous_weapon = selected_weapon
					selected_weapon = 4
					switch_weapons(previous_weapon, selected_weapon)
			elif Input.is_action_just_pressed("5"):
				if Weapons.WEAPON_SUPERNAILGUN in Global.unlocked_weapons:
					previous_weapon = selected_weapon
					selected_weapon = 5
					switch_weapons(previous_weapon, selected_weapon)


# Function for changing the weapon
func switch_weapons(previous, selected):
	selected_weapon = selected # Setting the selected weapon to the weapon given to the function, just in case.
	
	var current_tanslation = hands_translations[selected-1]
	
	$Head/Camera/GunCamera/ShootingAnimation.stop(false)
	
	$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/LeftArmIKPosition.translation = current_tanslation.left_hand_position
	$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition.translation = current_tanslation.right_hand_position
	
	#$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/LeftArmIKPosition.reset_physics_interpolation()
	#$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition.reset_physics_interpolation()
	
	$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIKPosition.rotation_degrees = Vector3.ZERO
	
	weapon_lookup[previous - 1].hide()
	weapon_lookup[selected - 1].show()
	
	if selected == Weapons.WEAPON_REVOLVER:
		revolver_crosshair.show()
		shotgun_crosshair.hide()
		nailgun_crosshair.hide()
		rocketlauncher_crosshair.hide()
	elif selected == Weapons.WEAPON_SHOTGUN:
		revolver_crosshair.hide()
		shotgun_crosshair.show()
		nailgun_crosshair.hide()
		rocketlauncher_crosshair.hide()
	elif selected == Weapons.WEAPON_NAILGUN:
		revolver_crosshair.hide()
		shotgun_crosshair.hide()
		nailgun_crosshair.show()
		rocketlauncher_crosshair.hide()
	elif selected == Weapons.WEAPON_ROCKETLAUNCHER:
		revolver_crosshair.hide()
		shotgun_crosshair.hide()
		nailgun_crosshair.hide()
		rocketlauncher_crosshair.show()
	elif selected == Weapons.WEAPON_SUPERNAILGUN:
		revolver_crosshair.hide()
		shotgun_crosshair.hide()
		nailgun_crosshair.hide()
		rocketlauncher_crosshair.hide()
	


func _process(delta):
	$Head/Camera/FPSCounter.text = str(Engine.get_frames_per_second())
	wallrun_bar.value = wallrun_charge
	
	if wallrun_charge == 100:
		wallrun_bar.modulate.a = lerp(wallrun_bar.modulate.a, 0, 20 * delta)
	else:
		wallrun_bar.modulate.a = lerp(wallrun_bar.modulate.a, 1, 30 * delta)
	
	for i in shotgun_raycasts.get_children():
		if i is RayCast:
			if i.is_colliding():
				shotgun_raycasts.get_node(str("MeshInstance", i.name.replace("RayCast", ""))).global_transform.origin = i.get_collision_point()
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	
	if is_on_floor():
		$HUD.rect_position.y = lerp($HUD.rect_position.y, 0, 10 * delta)
	else:
		$HUD.rect_position.y = lerp($HUD.rect_position.y, -20, 10 * delta)
	
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		#camera.set_as_toplevel(true)
		#camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		#camera.rotation.y = rotation.y
		#camera.rotation.x = head.rotation.x
		pass
	else:
		pass
		#camera.set_as_toplevel(false)
		#camera.global_transform.origin = head.global_transform.origin
		#$Head/Camera/GunCamera/ShootingAnimation.play("ShootRevolver")
	
	


func shoot():
	if selected_weapon in Global.unlocked_weapons:
		if Input.is_action_just_pressed("shoot") and can_shoot:
			if selected_weapon == Weapons.WEAPON_REVOLVER:
				if revolver.can_shoot:
					revolver.shoot()
			
			elif selected_weapon == Weapons.WEAPON_SHOTGUN:
				if shotgun.can_shoot:
					shotgun.shoot()
			
			elif selected_weapon == Weapons.WEAPON_ROCKETLAUNCHER:
				if rocketlauncher.can_shoot:
					rocketlauncher.shoot()
		
		if Input.is_action_pressed("shoot") and can_shoot:
			if selected_weapon == Weapons.WEAPON_NAILGUN:
				if nailgun.can_shoot:
					nailgun.shoot()
			if selected_weapon == Weapons.WEAPON_SUPERNAILGUN:
				if supernailgun.can_shoot:
					supernailgun.shoot()



func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	
	if can_control:
		f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	
	bounce.x = lerp(bounce.x, 0, 2 * delta)
	bounce.y = lerp(bounce.y, 0, 2 * delta)
	bounce.z = lerp(bounce.z, 0, 2 * delta)
	
	#bounce *= 0.9 * delta * 131
	
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):# or (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		bounce.x /= 2
		bounce.z /= 2
	#camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, h_input * 5, 100 * delta)
	#print(camera.rotation_degrees.z)
	
	
	if can_control:
		wallrun(delta)
		vault()
	
	update_ik()
	
	shoot()
	
	if speed_multiplier >= 1.4:
		#$Head/Camera/SpeedBoosted.show()
		speed_boost_bar.show()
		speed_boost_bar.material.set_shader_param('value', ($SpeedBoostTimer.time_left/$SpeedBoostTimer.wait_time)*100)
		#create_trail()
		if camera.fov < Settings.fov + 10:
			camera.fov = lerp(camera.fov, Settings.fov + 10, 7 * delta)
	else:
		if camera.fov > Settings.fov:
			camera.fov = lerp(camera.fov, Settings.fov, 7 * delta)
	
	process_animations(delta)
	#process_footsteps()
	
	
	if (h_input != 0 or f_input != 0) and is_on_floor():
		$Head/CameraAnimation.play("bobbing")
	
	
	#jumping and gravity
	if is_on_floor():
		if wallrun_charge < 100:
			wallrun_charge += 40 * delta
		elif wallrun_charge > 100:
			wallrun_charge = 100
		
		if !touched_ground:
			touched_ground = true
			ground_impact_animation()
		
		if !used_jump_boost:
			snap = -get_floor_normal()
			accel = ACCEL_DEFAULT
			jumps = 2
			gravity_vec = Vector3.ZERO
			#bounce = Vector3.ZERO
	
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		touched_ground = false
	
	if is_on_ceiling():
		gravity_vec.y = -1
	
	
	if can_control:
		if Input.is_action_just_pressed("jump") and jumps > 0:
			snap = Vector3.ZERO
			gravity_vec.y = jump
			jumps -= 1
			$WallrunTimer.start()
	
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed * speed_multiplier, accel * delta)
	movement = velocity + gravity_vec + bounce + moving_spatial_velocity
	
	
	if direction != Vector3.ZERO:
		AI.player_moved = true
	
	
	# Creating clone for prediction
	if clone_timer > 0.22:
		create_clone()
		clone_timer = 0
	else:
		clone_timer += delta
	
	
	
	prev_f_input = f_input
	prev_h_input = h_input
	
	prev_direction = direction
	
	
	move_vel = move_and_slide_with_snap(movement, snap, Vector3.UP)



# Function for wallrunning
func wallrun(delta:float):
	if is_on_wall() and ($WallrunLeft.is_colliding() or $WallrunRight.is_colliding()) and !is_on_floor() and can_wallrun and wallrun_charge > 0:
		gravity = wallrun_gravity
		speed = wallrun_speed
		jump = wall_jump
		jumps = 2
		if !on_wall:
			gravity_vec.y = 5
			on_wall = true
		
		wallrun_charge -= 60 * delta
		
		if $WallrunLeft.is_colliding():
			camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, -5, 10 * delta)
			model.rotation_degrees.z = lerp(model.rotation_degrees.z, 7, 10 * delta)
			if Input.is_action_just_pressed("jump"):
				#var gv_y = gravity_vec.y
				if Input.is_action_pressed("move_left"):# or Input.is_action_pressed("move_right"):
					bounce += $WallrunLeft.get_collision_normal() * 40 * speed_multiplier
				else:
					bounce += $WallrunLeft.get_collision_normal() * 20 * speed_multiplier
				#$BounceTimer.start()
				#gravity_vec.y = gv_y
		if $WallrunRight.is_colliding():
			camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, 5, 10 * delta)
			model.rotation_degrees.z = lerp(model.rotation_degrees.z, -7, 10 * delta)
			if Input.is_action_just_pressed("jump"):
				#var gv_y = gravity_vec.y
				if Input.is_action_pressed("move_right"):
					bounce += $WallrunRight.get_collision_normal() * 40 * speed_multiplier
				else:
					bounce += $WallrunRight.get_collision_normal() * 20 * speed_multiplier
				#$BounceTimer.start()
				#gravity_vec.y = gv_y
		
	else:
		gravity = normal_gravity
		speed = normal_speed
		jump = normal_jump
		
		if on_wall:
			on_wall = false
			can_wallrun = false
		
		camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, 0, 10 * delta)
		model.rotation_degrees.z = lerp(model.rotation_degrees.z, 0, 10 * delta)



# Function for vaulting over edges
func vault():
	if is_on_wall():
		if !$VaultingRaycast.is_colliding() and !($WallrunLeft.is_colliding() or $WallrunRight.is_colliding()):
			# This is to detect if the player isn't moving backwards
			if abs(f_input) != f_input:
				jumps = 1



# Function for creating the white trail
func create_trail():
	var trail = Global.trail.instance()
	Global.map.add_child(trail)
	trail.global_transform.origin = $TrailPosition.global_transform.origin



# Function for starting Inverse Kinematics
func start_ik():
	$PlayerModel/Armature/Skeleton/LeftArmIK.start()
	$PlayerModel/Armature/Skeleton/RightArmIK.start()
	$PlayerModel/Armature/Skeleton/LeftLegWalkIK.start()
	$PlayerModel/Armature/Skeleton/RightLegWalkIK.start()
	$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIK.start()
	$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/LeftArmIK.start()



func update_ik():
	if h_input != 0 or f_input != 0:
		if !(h_input == 0 and f_input == 1):
			$PlayerModel/Armature/Skeleton/LegWalkAnimation.play("walk")
			$PlayerModel/Armature/Skeleton/LegsWalkIKParent.rotation.y = Vector2(f_input, h_input).angle() + 3.14159
		else:
			$PlayerModel/Armature/Skeleton/LegWalkAnimation.play_backwards("walk")
			$PlayerModel/Armature/Skeleton/LegsWalkIKParent.rotation.y = 0
		
	else:
		$PlayerModel/Armature/Skeleton/LegsWalkIKParent.rotation.y = 0
	
	
	# Update head rotation
	var t = Transform(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0))
	$HeadIKLookat.global_transform.origin = head.global_transform.origin
	$HeadIKLookat.look_at(head_ik_position.global_transform.origin, Vector3.UP)
	model_skeleton.set_bone_custom_pose(1, t.rotated(Vector3.LEFT, $HeadIKLookat.rotation.x))



# Function for updating animations
func process_animations(delta):
	if !on_wall:
		# Rotating the arms and camera when moving left/right
		camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, -h_input * 1.5, 10 * delta)
		arms.rotation_degrees.z = lerp(arms.rotation_degrees.z, -h_input * 1.6, 10 * delta)
	
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward"):
		if is_on_floor() or on_wall:
			$Head/Camera/GunCamera/ArmsBobbingAnimation.play("ArmsBobbing")
		else:
			#arms.translation.y = lerp(arms.translation.y, velocity.y, 10 * delta)
			arms.translation.y = lerp(arms.translation.y, -2.4, 10 * delta)
			#arms.reset_physics_interpolation()
			$Head/Camera/GunCamera/ArmsBobbingAnimation.stop()
	else:
		arms.translation.y = lerp(arms.translation.y, -2.4, 10 * delta)
		#arms.reset_physics_interpolation()
		$Head/Camera/GunCamera/ArmsBobbingAnimation.stop()
	
	arms.translation.z = lerp(arms.translation.z, hands_translations[selected_weapon-1].viewmodel_z_position, 10 * delta)


# Function for making footstep sounds
func process_footsteps():
	if $FloorDetector.is_colliding():
		if h_input != 0 or f_input != 0:
			if !$FootSFX/FootstepsSound.playing:
				var s = Global.footsteps[randi() %8 -1]
				$FootSFX/FootstepsSound.stream = s
				$FootSFX/FootstepsSound.play()
				#yield($FootSFX/FootstepsSound, "finished")


# Function for camera shake
func shake_camera(amount:float=1.0, times:int=2):
	var t = 0.02
	var h_t = Tween.new()
	var v_t = Tween.new()
	
	add_child(h_t, true)
	add_child(v_t, true)
	
	for _i in range(times):
		var new_h_offset = amount * rand_range(-0.1, 0.1)
		var new_v_offset = amount * rand_range(-0.1, 0.1)
		#var new_rotation_offset = amount * Vector2(rand_range(-0.1, 0.1), rand_range(-0.1, 0.1))
		
		h_t.interpolate_property(camera, "h_offset", camera.h_offset, new_h_offset, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
		v_t.interpolate_property(camera, "v_offset", camera.v_offset, new_v_offset, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#h_t.interpolate_property(head, "rotation_degrees:y", head.rotation_degrees.y, new_rotation_offset.y, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#v_t.interpolate_property(head, "rotation_degrees:x", head.rotation_degrees.x, new_rotation_offset.x, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
		h_t.start()
		v_t.start()
		
		yield(h_t, "tween_completed")
	
	h_t.interpolate_property(camera, "h_offset", camera.h_offset, 0, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
	v_t.interpolate_property(camera, "v_offset", camera.v_offset, 0, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#h_t.interpolate_property(head, "rotation_degrees:y", head.rotation_degrees.y, 0, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#v_t.interpolate_property(head, "rotation_degrees:x", head.rotation_degrees.x, 0, t, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	yield(h_t, "tween_completed")
	
	h_t.queue_free()
	v_t.queue_free()
	


# Funcion for making the camera "bounce" when hitting the ground
func ground_impact_animation():
	ground_impact_tween.interpolate_property(head, "translation:y", 0.9, 0.9 + gravity_vec.y/40, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	ground_impact_tween.start()
	yield(ground_impact_tween, "tween_completed")
	ground_impact_tween.interpolate_property(head, "translation:y", head.translation.y, 0.9, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	ground_impact_tween.start()



# Function for creating prediction clone
func create_clone():
	if AI.spikes_enabled:
		if current_clone:
			if is_instance_valid(current_clone):
				#current_clone.velocity = Vector3.ZERO
				current_clone.queue_free()
		
		var c = Global.player_clone.instance()
		Global.map.add_child(c)
		
		
		c.global_transform.origin = global_transform.origin# + move_vel/10
		
		c.direction = direction
		c.snap = snap
		c.gravity = gravity
		c.speed = speed
		c.speed_multiplier = speed_multiplier
		c.can_wallrun = can_wallrun
		#c.movement = movement * 2
		
		c.velocity = velocity / get_physics_process_delta_time()
		c.gravity_vec = gravity_vec
		c.bounce = bounce
		
		#c.gravity_vec = gravity_vec * 2
		#c.velocity *= get_physics_process_delta_time() * 2
		
		current_clone = c



# Function for taking damage
func damage():
	health -= 1
	$HUD/HealthBar.update_healthbar()
	#$HUD/Healthbar.value = health
	#if $HUD/Healthbar.value == 1:
	#	$HUD/Healthbar.modulate = Color.red
	#elif $HUD/Healthbar.value >= 2:
	#	$HUD/Healthbar.modulate = Color.white
	
	shake_camera(0.7)
	
	if health <= 0:
		die()


# Function for committing die
func die():
	if Global.playing_custom_level:
		Global.level_editor.reset()
		return
	
	#$Foot.set_deferred('disabled', true)
	$CollisionShape.shape = death_collision_shape
	head.translation.y = 0.5
	#head.reset_physics_interpolation()
	arms.hide()
	shake_camera()
	
	can_control = false
	
	#Engine.time_scale = 0.5
	
	h_input = 0
	f_input = 0
	
	snap = Vector3.ZERO
	
	
	# Model
	model.rotation_degrees.x = -90
	model.translation.y = -0.6
	#model.reset_physics_interpolation()
	
	$PlayerModel/Armature/Skeleton/LeftLegWalkIK.stop()
	$PlayerModel/Armature/Skeleton/RightLegWalkIK.stop()
	$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/LeftArmIK.stop()
	$Head/Camera/GunCamera/PlayerArms/Armature/Skeleton/RightArmIK.stop()
	$PlayerModel/Armature/Skeleton/RightArmIK.stop()
	$PlayerModel/Armature/Skeleton/LeftArmIK.stop()
	
	$Head/Camera/SpringArm/ThirdPersonCamera.current = true
	camera.current = false
	
	$DeathScreen.show()
	$PauseMenu.hide()
	$HUD.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	health = 0


func show_hud():
	$HUD.show()

func hide_hud():
	$HUD.hide()


func _exit_tree():
	Global.player = null


func _on_WallrunTimer_timeout():
	can_wallrun = true


func _on_BounceTimer_timeout():
	bounce = Vector3.ZERO


func _on_SpeedBoostTimer_timeout():
	speed_multiplier = 1
	#$Head/Camera/SpeedBoosted.hide()
	speed_boost_bar.hide()


# Die when touching an enemy
func _on_EnemyDetector_body_entered(body):
	if body.is_in_group("MovingSpike"):
		die()
