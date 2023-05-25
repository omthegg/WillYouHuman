extends CSGBox


func _ready():
	hide()
	var box = BoxShape.new()
	box.extents = Vector3(width, height, depth)
	$Area/CollisionShape.shape = box
	#material.albedo_color.a = 0


func _on_Area_body_entered(body):
	if body.is_in_group('Player'):
		body.die()
		#var _c = get_tree().reload_current_scene()
