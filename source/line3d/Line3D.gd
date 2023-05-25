tool
extends Spatial

export var ending_position:Vector3 setget set_ending_position
export var color:Color = Color.white setget set_color
export var thickness:float = 1.0 setget set_thickness

func set_ending_position(new_ending_position):
	ending_position = new_ending_position
	$Spatial/MeshInstance.mesh.height = global_transform.origin.distance_to(new_ending_position)
	$Spatial.global_transform.origin = (new_ending_position - global_transform.origin) / 2
	
	if new_ending_position != global_transform.origin:
		$Spatial.look_at(new_ending_position, Vector3.UP)


func set_color(new_color):
	color = new_color
	$Spatial/MeshInstance.mesh.surface_get_material(0).albedo_color = new_color


func set_thickness(new_thickness):
	thickness = new_thickness
	$Spatial/MeshInstance.mesh.top_radius = new_thickness
	$Spatial/MeshInstance.mesh.bottom_radius = new_thickness
