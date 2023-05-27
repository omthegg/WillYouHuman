extends Node


#var trail = preload("res://source/trail/Trail.tscn")
var player_clone = preload("res://source/player/PlayerClone.tscn")
var spike = preload("res://source/spike/Spike.tscn")
var new_spike = preload("res://source/spike/NewSpike.tscn")
var spike_spawn = preload("res://source/spikespawn/SpikeSpawn.tscn")
var explosion_effect = preload("res://source/explosioneffect/ExplosionEffect.tscn")
var smiley = preload("res://source/smiley/Smiley.tscn")
var shot_impact = preload("res://source/shotimpact/ShotImpact.tscn")
var player_rocket = preload("res://source/PlayerRocket/PlayerRocket.tscn")
var bfg_projectile = preload("res://source/BFGProjectile/BFGProjectile.tscn")
var line_renderer
var enemy_bullet = preload("res://source/enemies/EnemyBullet/EnemyBullet.tscn")
var nailgun_projectile = preload("res://source/NailgunProjectile/NailgunProjectile.tscn")
var entity_spawner = preload("res://source/EntitySpawner/EntitySpawner.tscn")
var polygon3d = preload("res://source/Polygon3D/Polygon3D.tscn")
var bomb = preload("res://source/bomb/Bomb.tscn")


var environments = [
	preload("res://source/environments/Environment1.tres"),
	preload("res://source/environments/SmileyMinigameEnvironment.tres")
]


var footsteps = [
	preload("res://assets/sounds/jute-dh-steps/stepstone_1.wav"),
	preload("res://assets/sounds/jute-dh-steps/stepstone_2.wav"),
	preload("res://assets/sounds/jute-dh-steps/stepstone_3.wav"),
	preload("res://assets/sounds/jute-dh-steps/stepstone_4.wav"),
	preload("res://assets/sounds/jute-dh-steps/stepstone_5.wav"),
	preload("res://assets/sounds/jute-dh-steps/stepstone_6.wav"),
	preload("res://assets/sounds/jute-dh-steps/stepstone_7.wav"),
	preload("res://assets/sounds/jute-dh-steps/stepstone_8.wav")
]


# GIBS
var guard_gib = preload("res://source/Gibs/GuardGib.tscn")


var windowed_resolution = Vector2(1024, 600)

var map
var player:KinematicBody
var squid_representation:Spatial
var level_editor

var predicting_timer = 0.0
var player_start_pos:Vector3
var player_previous_pos
var player_velocity

var unlocked_weapons = []

var timer = 0.0

var enemy_count = 0

var console_open = false

var editing_level = false
var playing_custom_level = false

var l = Label.new()


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	VisualServer.texture_set_shrink_all_x2_on_set_data(true)
	
	add_child(l)
	#Settings.set_viewport_size(Vector2(1024/5, 600/5))


func _physics_process(_delta):
	enemy_count = get_tree().get_nodes_in_group("Enemy").size()
	
	if player:
		player_velocity = player.global_transform.origin - player_previous_pos
		player_previous_pos = player.global_transform.origin
		#print(player_velocity)
	#else:
		#player_previous_pos = player.global_transform.origin


func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		if !OS.window_fullscreen:
			change_resolution(windowed_resolution)
		#get_viewport().size = Vector2(480, 320)



# Function for giving/unlocking a weapon for the player.
# 1 : revolver
# 2 : shotgun
# 3 : nailgun
# 4 : rocket launcher
func unlock_weapon(weapon:int):
	if !(weapon in unlocked_weapons):
		if unlocked_weapons.size() == 0:
			player.switch_weapons(0, weapon)
			player.arms.show()
		
		unlocked_weapons.append(weapon)


func change_windowed_resolution(resolution:Vector2):
	windowed_resolution = resolution
	if !OS.window_fullscreen:
		change_resolution(windowed_resolution)


# Only use for windowed mode
func change_resolution(resolution:Vector2):
	#get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, resolution, 1)
	if !OS.window_fullscreen:
		print(get_viewport().size)
		get_viewport().size = resolution
	#get_tree().get_root().set_size_override(true, resolution / Vector2(1024, 600))
	#OS.set_window_size(resolution)


func load_custom_map(location:String):
	get_tree().paused = true
	unlock_weapon(5)
	var _v = get_tree().change_scene("res://source/MapTester/MapTester.tscn")
	
	var r = get_node_or_null("/root/MapTester")
	while r == null:
		yield(get_tree(), "idle_frame")
		r = get_node_or_null("/root/MapTester")
	
	var qodot_node:QodotMap = get_node("/root/MapTester/Navigation/NavigationMeshInstance/QodotMap")
	var navigation_mesh_instance:NavigationMeshInstance = get_node("/root/MapTester/Navigation/NavigationMeshInstance")
	
	qodot_node.map_file = location
	
	qodot_node.verify_and_build()
	
	yield(qodot_node, "build_complete")
	navigation_mesh_instance.bake_navigation_mesh()
	yield(navigation_mesh_instance, "bake_finished")
	get_tree().paused = false
	print("Loading finished")



func create_particles(position:Vector3, gravity:Vector3=Vector3.ZERO, size:Vector2=Vector2(1, 1), amount:int=5, color:Color=Color.white, lifetime:float=1.0, explosiveness:float = 0.5, one_shot:bool = true, emission_radius:float=1.0, initial_velocity:float=0.0):
	var particles = Particles.new()
	get_tree().get_root().add_child(particles)
	particles.global_transform.origin = position
	particles.lifetime = lifetime
	particles.amount = amount
	particles.explosiveness = explosiveness
	
	var particles_material = ParticlesMaterial.new()
	particles_material.gravity = gravity
	#particles_material.scale = size
	particles_material.emission_shape = ParticlesMaterial.EMISSION_SHAPE_SPHERE
	particles_material.emission_sphere_radius = emission_radius
	
	var scale_curve = CurveTexture.new()
	scale_curve.curve = Curve.new()
	scale_curve.curve.clear_points()
	scale_curve.curve.add_point(Vector2(0.0, 1.0))
	scale_curve.curve.add_point(Vector2(1.0, 0.0))
	particles_material.scale_curve = scale_curve
	
	var draw_pass = QuadMesh.new()
	draw_pass.size = size
	
	var draw_pass_material = SpatialMaterial.new()
	draw_pass_material.albedo_color = color
	draw_pass_material.flags_unshaded = true
	draw_pass_material.params_billboard_mode = SpatialMaterial.BILLBOARD_PARTICLES
	
	draw_pass.material = draw_pass_material
	particles.draw_pass_1 = draw_pass
	particles.process_material = particles_material
	
	particles.one_shot = one_shot
	particles.emitting = true
	
	return particles
