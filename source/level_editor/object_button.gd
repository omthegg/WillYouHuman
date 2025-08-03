extends TextureButton

@export var scene:PackedScene

@onready var level_editor:Node3D = get_tree().root.get_node("LevelEditor")

func _ready() -> void:
	$SubViewport.add_child(scene.instantiate())
	set_texture()

func set_texture() -> void:
	await RenderingServer.frame_post_draw
	var texture:Texture2D = $SubViewport.get_texture()
	texture_normal = texture


func _on_pressed():
	level_editor.selected_scene = scene
