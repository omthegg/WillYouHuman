extends Spatial

onready var propeller1 = $Propeller1
onready var propeller2 = $Propeller2
onready var propeller3 = $Propeller3
onready var propeller4 = $Propeller4

var speed = 20

var player:KinematicBody

var velocity = Vector3()

var update_velocity_timer = 0.0

func _physics_process(_delta):
	velocity = Vector3.ZERO
	
	if player:
		var p_pos = player.global_transform.origin
		var pos = global_transform.origin
		
		if pos.distance_squared_to(p_pos) != 0:
			$lookat.look_at(player.global_transform.origin, Vector3.UP)
		
		var look = player.global_transform.origin
		
		
		# Don't try looking at the player if it's right
		# above or below you. To prevent an error
		if pos.distance_squared_to(p_pos) != 0:
			look_at(look, Vector3.UP)
		
		rotation_degrees.x = -14
		
	else:
		player = Global.player

