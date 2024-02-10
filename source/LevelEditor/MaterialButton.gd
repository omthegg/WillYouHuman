extends TextureButton
class_name MaterialButton

var template_material:Material
var material_name:String = "Material"

var viewport = Viewport.new()
var camera = Camera.new()
var mesh_instance = MeshInstance.new()
var sphere = SphereMesh.new()

func _ready():
	add_to_group("EditorButton", true)
	rect_min_size = Vector2(64, 64)
	expand = true
	flip_v = true
	toggle_mode = true
	action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	#print(material_name)


func add_children():
	add_child(viewport)
	viewport.size = Vector2(128, 128)
	viewport.transparent_bg = true
	viewport.own_world = true
	viewport.world = World.new()
	viewport.world.environment = Environment.new()
	viewport.world.environment.ambient_light_color = Color.white
	
	viewport.add_child(camera, true)
	camera.translation.z += 1
	
	viewport.add_child(mesh_instance, true)
	sphere.height = 1.0
	sphere.radius = 0.5
	sphere.radial_segments = 8
	sphere.rings = 4
	mesh_instance.mesh = sphere
	mesh_instance.material_override = template_material
	
	yield(get_tree(), "idle_frame")
	
	var texture = viewport.get_texture()
	texture_normal = texture
	texture_pressed = texture
	texture_hover = texture


func _pressed():
	update()
	
	Global.level_editor.unpress_material_buttons()
	pressed = true
	
	Global.level_editor.selected_material = template_material
	
	if Global.level_editor.selected_object:
		if is_instance_valid(Global.level_editor.selected_object):
			if Global.level_editor.selected_object.is_in_group("Polygon3D"):
				#Global.level_editor.selected_object.get_node("MeshInstance").material_override = template_material
				Global.level_editor.selected_object.material = template_material

func _draw():
	if pressed:
		draw_rect(Rect2(Vector2(0, 0), Vector2(64, 64)), Color.green, false, 4)
