extends StaticBody

onready var outside_mesh_instance = $Outside
onready var inside_mesh_instance = $Inside
onready var collision_shape = $CollisionShape
onready var static_body_collision_shape = $StaticBody/CollisionShape

export var max_health = 100.0
var health = 100.0

export var speed = 100.0
export var fall_direction:Vector3 = Vector3(0, -1, 0)

var broken = false

func _ready():
	health = max_health
	outside_mesh_instance.mesh = collision_shape.shape.get_debug_mesh()
	
	if !Global.editing_level:
		collision_shape.disabled = true

func damage(amount):
	if health > 0:
		health -= amount
		print(health)
		inside_mesh_instance.scale = Vector3(1, 1, 1) * ((health / max_health))
		#print(((health / max_health)))
		if health <= 0:
			health = 0
			break_block()
	

func break_block():
	broken = true
	inside_mesh_instance.scale = Vector3(1, 1, 1)
	constant_linear_velocity = fall_direction * speed
