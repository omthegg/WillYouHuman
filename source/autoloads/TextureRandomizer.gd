extends Node

var icon = preload("res://godot.png")
var floor1 = preload("res://textures/floor1.png")

var repeating_texture

func generate_random_texture(repeating_texture_size:int=1024, texture_size:int=512, keep_repeating_texture = true):
	var rects = []
	
	if !keep_repeating_texture or (keep_repeating_texture and repeating_texture == null):
		repeating_texture = Image.new()
		repeating_texture.create(1024, 1024, true, Image.FORMAT_RGB8)
		for x in range(0, 1024, 64):
			for y in range(0, 1024, 64):
				repeating_texture.blit_rect(floor1.get_data(), Rect2(0, 0, 64, 64), Vector2(x, y))
		
		#repeating_texture.save_png("C:/Users/EXO/Desktop/repeating_texture.png")
	
	randomize()
	var r = Rect2()
	r.position = Vector2(0, 0)
	r.size = Vector2(512, 512)
	rects.append(r)
	var x_or_y = 1
	for _i in range(100):
		var sorted_bigger_rects = sort_rects_array(rects.duplicate())
		if sorted_bigger_rects.size() > 2:
			sorted_bigger_rects.resize(int(sorted_bigger_rects.size()/1.4))
		
		var random_rect = sorted_bigger_rects[randi()%sorted_bigger_rects.size()]
		
		if random_rect.size.y == random_rect.size.x:
			x_or_y = randi() %2
		elif random_rect.size.y > random_rect.size.x:
			x_or_y = 1
		else:
			x_or_y = 0
		
		var slice1 = random_rect
		if x_or_y == 1:
			slice1.size *= Vector2(1.0, 0.5)
		else:
			slice1.size *= Vector2(0.5, 1.0)
		
		var slice2 = random_rect
		if x_or_y:
			slice2.position += slice2.size * Vector2(0.0, 0.5)
			slice2.size *= Vector2(1.0, 0.5)
		else:
			slice2.position += slice2.size * Vector2(0.5, 0.0)
			slice2.size *= Vector2(0.5, 1.0)
		
		rects.erase(random_rect)
		rects.append(slice1)
		rects.append(slice2)
	
	
	var img = Image.new()
	img.create(512, 512, false, Image.FORMAT_RGB8)
	
	for rect in rects:
		var randomly_scaled_texture = repeating_texture.duplicate()
		#randomly_scaled_texture = icon.get_data()
		#randomly_scaled_texture.resize(Vector2(64.0*rand_range(1.0, 2.0), 64.0*rand_range(1.0, 2.0)))
		var random_size_x = stepify(1024*rand_range(1.0, 2.0), 16.0)
		#randomize()
		var random_size_y = stepify(1024*rand_range(1.0, 2.0), 16.0)
		randomly_scaled_texture.resize(random_size_x, random_size_y, 0)
		randomly_scaled_texture.crop(rect.size.x, rect.size.y)
		#img.blit_rect(randomly_scaled_texture, Rect2(Vector2(0, 0), rect.size), rect.position)
		img.blit_rect(randomly_scaled_texture, Rect2(Vector2(0, 0), rect.size), rect.position)
		#print(rect)
		#img.fill_rect(rect, Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0)))
	
	#img.save_png("C:/Users/EXO/Desktop/rand.png")
	
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(img, 3)
	
	return image_texture


func find_biggest_rect(rects_array: Array):
	var biggest_so_far = rects_array[0]
	for i in rects_array.size() - 1:
		if biggest_so_far.size.x*biggest_so_far.size.y < rects_array[i + 1].size.x*rects_array[i + 1].size.y:
			biggest_so_far = rects_array[i + 1]
	return biggest_so_far


func sort_rects_array(rects_array: Array):
	var new_array = []
	for i in rects_array.size():
		var result = find_biggest_rect(rects_array)
		#adds smallest number to new array
		new_array.append(result)
		#removes the number from the variable number
		rects_array.remove(rects_array.find(result))
	return new_array


func generate_random_textures_for_array(objects:Array, one_for_all:bool=true):
	if one_for_all:
		var texture = generate_random_texture()
		var material = SpatialMaterial.new()
		material.uv1_scale = Vector3(0.04, 0.04, 0.04)
		material.uv1_triplanar = true
		material.flags_world_triplanar = true
		material.albedo_color = Global.map.color
		material.albedo_texture = texture
		for object in objects:
			if (object.is_in_group("Polygon3D")) or (object is CSGShape):
				object.material = material
	
	else:
		for object in objects:
			if object.is_in_group("Polygon3D"):
				var texture = generate_random_texture()
				var material = SpatialMaterial.new()
				material.uv1_scale = Vector3(0.04, 0.04, 0.04)
				material.uv1_triplanar = true
				material.flags_world_triplanar = true
				material.albedo_color = object.material.albedo_color
				material.albedo_texture = texture
				object.material = material
				#object.material.albedo_texture = texture
			
			elif object is CSGShape:
				var texture = generate_random_texture()
				var material = SpatialMaterial.new()
				material.uv1_scale = Vector3(0.04, 0.04, 0.04)
				material.uv1_triplanar = true
				material.flags_world_triplanar = true
				material.albedo_color = object.material.albedo_color
				material.albedo_texture = texture
				object.material = material
