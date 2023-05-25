extends Spatial

export var color:Color

func _ready():
	$OmniLight.light_color = color
	$MeshInstance.material_override.albedo_color = color
	$MeshInstance.material_override.emission = color
