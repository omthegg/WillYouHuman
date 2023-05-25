extends StaticBody

export var entity_name:String = "Entity" setget set_name
export var scene:PackedScene
export var offset:Vector3
export var color:Color setget set_color

func spawn():
	var scene_instance = scene.instance()
	get_parent().add_child(scene_instance)
	scene_instance.global_transform.origin = global_transform.origin + offset
	scene_instance.global_rotation = global_rotation
	
	queue_free()

func set_color(value):
	color = value
	var mat = $MeshInstance.get("material/0")
	mat.albedo_color = color

func set_name(value):
	entity_name = value
	$Label3D.text = entity_name
