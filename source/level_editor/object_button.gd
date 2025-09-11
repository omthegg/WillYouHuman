extends TextureButton

@export var scene:PackedScene
@export var offset:Vector3 = Vector3.ZERO
@export var camera_size:float = 2.0
@export var scene_rotation:Vector3 = Vector3.ZERO

@onready var level_editor:Node3D
@onready var camera:Camera3D = $SubViewport/Camera3D

func _ready() -> void:
	var scene_instance:Node = scene.instantiate()
	$SubViewport.add_child(scene_instance)
	
	if scene_instance.name == "Box":
		scene_instance.enable_size_tools()
		scene_instance.material = Global.display_material
	elif scene_instance.name == "Polygon":
		scene_instance.enable_polygon_tools()
		scene_instance.material = Global.display_material
	
	scene_instance.process_mode = Node.PROCESS_MODE_DISABLED
	scene_instance.position += offset
	scene_instance.rotation_degrees = scene_rotation
	
	camera.size = camera_size
	set_texture()

func set_texture() -> void:
	await RenderingServer.frame_post_draw
	var texture:Texture2D = $SubViewport.get_texture()
	texture.resource_local_to_scene = true
	texture_normal = texture


func _on_pressed():
	level_editor = Global.scene_manager.level_editor
	level_editor.selected_scene = scene
	get_node("../../SelectionOverlay").global_position = global_position
