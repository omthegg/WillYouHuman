extends CSGPolygon3D

@export var cylinder_mode:bool = false:
	set(value):
		cylinder_mode = value
		mode = int(cylinder_mode)

@export var collision:bool = true
@export var rotate_y_90_degrees:bool = false:
	set(value):
		rotate_y_90_degrees = value
		rotation_degrees.y = 90 * int(value)

@onready var pt0:Node3D = $PolygonTool0
@onready var pt1:Node3D = $PolygonTool1
@onready var pt2:Node3D = $PolygonTool2
@onready var pt3:Node3D = $PolygonTool3
@onready var polygon_tools:Array = [pt0, pt1, pt2, pt3]

func _ready() -> void:
	disable_polygon_tools()

func _physics_process(_delta) -> void:
	for i in range(polygon_tools.size()):
		var pt:Node3D = polygon_tools[i]
		polygon[i] = Vector2(pt.position.x, pt.position.y)
	
	var highlight:MeshInstance3D = get_node_or_null("EditorHighlight")
	if highlight:
		highlight.mesh = get_meshes()[1]
		highlight.position = Vector3(-0.005, -0.005, 0.005)
	
	reset_polygon_tools()


func reset_polygon_tools() -> void:
	for i in range(polygon_tools.size()):
		var pt:Node3D = polygon_tools[i]
		pt.position.x = polygon[i].x
		pt.position.y = polygon[i].y

func enable_polygon_tools() -> void:
	for pt in polygon_tools:
		pt.show()
		pt.get_node("DraggingComponent/CollisionShape3D").disabled = false

func disable_polygon_tools() -> void:
	for pt in polygon_tools:
		pt.hide()
		pt.get_node("DraggingComponent/CollisionShape3D").disabled = true
