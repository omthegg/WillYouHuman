extends Node

var mouse_sens:float = 0.003

#func _ready() -> void:
	#var sprite:Sprite2D = Sprite2D.new()
	#sprite.centered = false
	#sprite.scale = Vector2(0.5, 0.5)
	#add_child(sprite)
	#sprite.texture = generate_random_texture()


func generate_random_texture(size:int = 1024) -> Texture2D:
	var rects:Array[Rect2i] = []
	# Add a starting rect that covers the whole image
	rects.append(Rect2i(Vector2i(0, 0), Vector2i(size, size)))
	# How many cuts we can do
	var times:int = size/8
	for i in range(times):
		# Choose a rect
		rects.sort_custom(sort_rects)
		var rect:Rect2i = rects[randi_range(0, (rects.size()-1)/2)]#rects[randi_range(0, rects.size()-1)]
		# Should the cut be vertical?
		var vertical:bool = bool(randf_range(0, rect.size.x/rect.size.y))
		
		# Cut rect in half
		var rect1:Rect2i
		var rect2:Rect2i
		
		if vertical:
			rect1.position = rect.position
			rect1.size = Vector2i(rect.size.x/2, rect.size.y)
			rect2.position = rect.position + Vector2i(rect.size.x/2, 0)
			rect2.size = rect1.size
		else:
			rect1.position = rect.position
			rect1.size = Vector2i(rect.size.x, rect.size.y/2)
			rect2.position = rect.position + Vector2i(0, rect.size.y/2)
			rect2.size = rect1.size
		
		rects.append(rect1)
		rects.append(rect2)
		rects.erase(rect)
	
	var img:Image = Image.create_empty(size, size, false, Image.FORMAT_RGB8)
	img.fill(Color.BLACK)
	for rect in rects:
		img.fill_rect(rect, Color.WHITE)
		var lt:int = 2 # Line thickness
		var rect_s = Rect2i(Vector2i(rect.position.x+lt, rect.position.y+lt), Vector2i(rect.size.x-2*lt, rect.size.y-2*lt))
		img.fill_rect(rect_s, Color.BLACK)
	
	var texture = ImageTexture.create_from_image(img)
	
	return texture


## See sort_custom for arrays
func sort_rects(a:Rect2i, b:Rect2i) -> bool:
	if (a.size.x + a.size.y) > (b.size.x + b.size.y):
		return true
	return false


func create_line_mesh(vertices:PackedVector3Array) -> ArrayMesh:
	var mesh:ArrayMesh = ArrayMesh.new()
	var arrays:Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	return mesh
