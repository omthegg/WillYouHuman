extends ImmediateGeometry
class_name Line3D

export var line_begin:Vector3
export var line_end:Vector3
export var color:Color = Color.whitesmoke

func _process(_delta):
	clear()
	begin(Mesh.PRIMITIVE_LINES)
	
	set_normal(Vector3(0, 0, 1))
	set_uv(Vector2(0, 0))
	set_color(color)
	add_vertex(line_begin)
	set_normal(Vector3(0, 0, 1))
	set_uv(Vector2(0, 1))
	set_color(color)
	add_vertex(line_end)
	
	end()
