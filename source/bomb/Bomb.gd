extends RigidBody

var time:int = 5

onready var label = $Label3D
onready var timer = $Timer

func _ready():
	label.set_as_toplevel(true)
	if Global.editing_level:
		mode = RigidBody.MODE_STATIC
		label.hide()
	else:
		timer.start(time+1)
	
	#$Tween.interpolate_property($MeshInstance, "material_override:albedo_color", $MeshInstance.material_override.albedo_color, $MeshInstance.material_override.albedo_color - Color(0.1, 0.1, 0.1), 1.0, Tween.TRANS_BACK, Tween.EASE_IN)


func _process(_delta):
	label.global_transform.origin = global_transform.origin + Vector3(0, 1.3, 0)
	label.text = str(int(timer.time_left))


func _on_Timer_timeout():
	pass
