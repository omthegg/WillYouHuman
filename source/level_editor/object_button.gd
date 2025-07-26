extends TextureButton

func _ready() -> void:
	set_texture()

func set_texture() -> void:
	await RenderingServer.frame_post_draw
	var texture:Texture2D = $SubViewport.get_texture()
	texture_normal = texture
