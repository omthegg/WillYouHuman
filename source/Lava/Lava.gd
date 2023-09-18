extends "res://source/Polygon3D/Polygon3D.gd"

onready var lava_mesh_instance = $LavaMeshInstance
onready var area_collision_shape = $Area/CollisionShape

func _ready():
	collision_shape.disabled = true


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.damage()
		body.damage()
		body.damage()


# this is bad
func _process(_delta):
	lava_mesh_instance.mesh = mesh_instance.mesh

func _physics_process(_delta):
	area_collision_shape.shape = collision_shape.shape
