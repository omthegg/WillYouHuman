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
	for i in range(8):
		var img = Image.new()
		img.create(128, 128, true, Image.FORMAT_RGB8)
		for rect in rects:
		#	print(rect)
			img.fill_rect(rect, Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0)))
		
		img.save_png(str("C:/Users/EXO/Desktop/", str(i), ".png"))
		
		#var sorted_bigger_rects = rects.duplicate(true)
		#sorted_bigger_rects.sort()
		var sorted_bigger_rects = sort_rects_array(rects.duplicate())
		if sorted_bigger_rects.size() > 2:
			sorted_bigger_rects.resize(int(sorted_bigger_rects.size()/2))
		
		var random_rect = sorted_bigger_rects[randi()%sorted_bigger_rects.size()]
		
		#x_or_y *= -1
		x_or_y = random_rect.size.y > random_rect.size.x
		
		var slice1 = random_rect
		#slice1.position = random_rect.position
		if x_or_y:
			slice1.size *= Vector2(1.0, 0.5)
		else:
			slice1.size *= Vector2(0.5, 1.0)
		
		var slice2 = random_rect
		#slice2.position = random_rect.position + random_rect.size * Vector2(0.0, 1.0)
		if x_or_y:
			slice2.position += slice2.size * Vector2(0.0, 0.5)
			slice2.size *= Vector2(1.0, 0.5)
		else:
			slice2.position += slice2.size * Vector2(0.5, 0.0)
			slice2.size *= Vector2(0.5, 1.0)
		
		rects.erase(random_rect)
		rects.append(slice1)
		rects.append(slice2)
	
	#var sorted_bigger_rects = rects.duplicate(true)
	#sorted_bigger_rects.sort()
	#if sorted_bigger_rects.size() > 2:
	#	sorted_bigger_rects.resize(int(sorted_bigger_rects.size()/2))
	#print(sorted_bigger_rects)
	
	var img = Image.new()
	img.create(128, 128, true, Image.FORMAT_RGB8)
	for rect in rects:
		#print(rect)
		img.fill_rect(rect, Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0)))
	
	img.save_png("C:/Users/EXO/Desktop/rand.png")


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
