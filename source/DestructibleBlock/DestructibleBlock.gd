extends RigidBody

onready var outside_mesh_instance = $Outside
onready var inside_mesh_instance = $Inside
onready var collision_shape = $CollisionShape
onready var static_body_collision_shape = $StaticBody/CollisionShape

export var max_health = 50.0
var health = 50.0

export var speed = 1.0

func _ready():
	health = max_health
	outside_mesh_instance.mesh = collision_shape.shape.get_debug_mesh()
	
	if !Global.editing_level:
		collision_shape.disabled = true

func damage(amount):
	health -= amount
	print(health)
	inside_mesh_instance.scale = Vector3(1, 1, 1) * (1.0 - ((health / max_health) * 1.0))
	#print(((health / max_health)))
	if health <= 0:
		break_block()

func break_block():
	pass
