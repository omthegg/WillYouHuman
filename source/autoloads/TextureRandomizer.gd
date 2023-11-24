extends Node

var icon = preload("res://godot.png")

var rects = []

func generate_random_texture():
	randomize()
	var r = Rect2()
	r.position = Vector2(0, 0)
	r.size = Vector2(128, 128)
	rects.append(r)
	var x_or_y = 1
	for i in range(4):
		var img = Image.new()
		img.create(128, 128, true, Image.FORMAT_RGB8)
		for rect in rects:
		#	print(rect)
			img.fill_rect(rect, Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0)))
		
		img.save_png(str("C:/Users/EXO/Desktop/", str(i), ".png"))
		
		var random_rect = rects[randi()%rects.size()]
		
		x_or_y *= -1
		
		var slice1 = random_rect
		#slice1.position = random_rect.position
		if x_or_y == 1:
			slice1.size *= Vector2(1.0, 0.5)
		else:
			slice1.size *= Vector2(0.5, 1.0)
		
		var slice2 = random_rect
		#slice2.position = random_rect.position + random_rect.size * Vector2(0.0, 1.0)
		if x_or_y == 1:
			slice2.position += slice2.size * Vector2(0.0, 0.5)
			slice2.size *= Vector2(1.0, 0.5)
		else:
			slice2.position += slice2.size * Vector2(0.5, 0.0)
			slice2.size *= Vector2(0.5, 1.0)
		
		rects.erase(random_rect)
		rects.append(slice1)
		rects.append(slice2)
	
	var img = Image.new()
	img.create(128, 128, true, Image.FORMAT_RGB8)
	for rect in rects:
		#print(rect)
		img.fill_rect(rect, Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0)))
	
	img.save_png("C:/Users/EXO/Desktop/rand.png")
