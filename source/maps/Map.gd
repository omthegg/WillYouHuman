extends Spatial

class_name Map

export var spikes_enabled:bool = false

enum LEVEL_TYPE {
	NORMAL = 0,
	DISCO = 1,
	UNDERWATER = 2,
	BUBBLEGUM = 3
}

var level_light_lut = [
	"5d5d5d",
	"000000"
]

enum LEVEL_LIGHT {
	BRIGHT = 0,
	DARK = 1
}


export(int, 0, 3) var level_type
export(int, 0, 1) var level_light setget set_level_light

export var color:Color = Color("ffd100") setget set_color

export var take_revolver = false
export var give_revolver = false
export var take_shotgun = false
export var give_shotgun = false
export var take_nailgun = false
export var give_nailgun = false
export var take_rocketlauncher = false
export var give_rocketlauncher = false

var animation_thread = Thread.new()
var texture_randomization_thread = Thread.new()

var animated_materials = []
var colliding_csg = []


var colored_materials = [
	#preload("res://source/materials/floor1_1.tres"),
	#preload("res://source/materials/wall1_1.tres"),
	preload("res://textures/floor1.tres"),
	preload("res://textures/floor2.tres"),
	preload("res://textures/wall1.tres")
]

var colored_materials_tweens = []

#var pulse_value = -1.0

func _init():
	VisualServer.set_debug_generate_wireframes(true)

func _input(event):
	if event is InputEventKey and Input.is_action_just_pressed("viewmode"):
		var vp = get_viewport()
		vp.debug_draw = (vp.debug_draw + 1 ) % 4



func _ready():
	#Engine.time_scale = 0.5
	Global.map = self
	Global.unlocked_weapons = []
	for i in get_all_children(self):
		if i is CSGShape:
			#var m = SpatialMaterial.new()
			#m.albedo_texture = TextureRandomizer.generate_random_texture()
			#i.material = m
			#yield(get_tree(), "idle_frame")
			if i.material is SpatialMaterial:
				if i.material.albedo_texture is AnimatedTexture:
					if !animated_materials.has(i.material):
						animated_materials.append(i.material)
	
	AI.spikes_enabled = spikes_enabled
	
	if level_type == LEVEL_TYPE.DISCO:
		for i in range(len(colored_materials)):
			colored_materials_tweens.append(Tween.new())
			add_child(colored_materials_tweens[i])
	
	if level_light == LEVEL_LIGHT.BRIGHT:
		get_node("WorldEnvironment").environment.ambient_light_energy = 5
	if level_light == LEVEL_LIGHT.DARK:
		get_node("WorldEnvironment").environment.ambient_light_energy = 0.1
	
	for i in colored_materials:
		i.albedo_color = color
	
	
	if !Global.editing_level:
		spawn_entities()
		
		yield(get_tree(), "idle_frame")
		if Global.player:
			Global.player.camera.current = true
		
		#$Navigation/NavigationMeshInstance.bake_navigation_mesh()
	
	Global.generate_random_textures_for_array(get_node("Navigation/NavigationMeshInstance").get_children())
	#$TextureTest.material.albedo_texture = TextureRandomizer.generate_random_texture()
	#print($TextureTest.material.albedo_texture)
	#$TextureTest.material.albedo_texture.get_data().save_png("C:/Users/EXO/Desktop/test.png")




func _process(delta):
	if !animation_thread.is_active():
		animation_thread.start(self, 'pause_animations')
	
	#pause_animations()
	
	if level_type == LEVEL_TYPE.DISCO:
		disco_lights()
	
	#pulse_value += delta
	#if pulse_value >= 1.0:
	#	pulse_value = -1.0
	
	#var r = deg2rad(pulse_value)
	#print(r)
	#get_node("WorldEnvironment").environment.adjustment_brightness += sin(r)/6



func pause_animations():
	for i in animated_materials:
		var p = Global.player
		
		if (p.velocity.x > 15 or p.velocity.x < -14) or (p.velocity.z > 16 or p.velocity.z < -16):
			i.albedo_texture.pause = true
		else:
			i.albedo_texture.pause = false
		


func disco_lights():
	for i in range(len(colored_materials)):
		if !(colored_materials_tweens[i].is_active()):
			if colored_materials[i].albedo_color == Color(0, 1, 0):
				colored_materials_tweens[i].interpolate_property(colored_materials[i], "albedo_color", Color(0, 1, 0), Color(1, 0, 1), 3)
			elif colored_materials[i].albedo_color == Color(1, 0, 1):
				colored_materials_tweens[i].interpolate_property(colored_materials[i], "albedo_color", Color(1, 0, 1), Color(0, 1, 0), 3)
			else:
				colored_materials[i].albedo_color = Color(0, 1, 0)
			
			colored_materials_tweens[i].start()


func set_color(value:Color):
	for i in colored_materials:
		i.albedo_color = value
	
	color = value


func set_level_light(value):
	level_light = value
	
	
	if !get_node_or_null("WorldEnvironment"):
		yield(self, "ready")
	if level_light == LEVEL_LIGHT.BRIGHT:
		get_node("WorldEnvironment").environment.ambient_light_energy = 5
	if level_light == LEVEL_LIGHT.DARK:
		get_node("WorldEnvironment").environment.ambient_light_energy = 0.1


func spawn_entities():
	for child in get_all_children(self):
		if child.is_in_group("EntitySpawner"):
			child.spawn()
			child.hide()


func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr


func _exit_tree():
	if animation_thread.is_active():
		animation_thread.wait_to_finish()

