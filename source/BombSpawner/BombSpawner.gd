extends StaticBody

export var spawner_timer:int = 5.0
export var bomb_timer:int = 5.0

onready var timer = $Timer
onready var mesh_instance = $MeshInstance

func _ready():
	if !Global.editing_level:
		$CollisionShape.disabled = true
		timer.start(spawner_timer)


func _physics_process(_delta):
	mesh_instance.get_surface_material(0).set_shader_param("progress", timer.time_left / spawner_timer)


func _on_Timer_timeout():
	var bomb_instance = Global.bomb.instance()
	get_tree().get_root().add_child(bomb_instance)
	bomb_instance.time = bomb_timer
	bomb_instance.global_transform.origin = global_transform.origin
	timer.start(spawner_timer)
