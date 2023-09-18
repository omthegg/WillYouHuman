extends RigidBody

onready var ground_detector = $GroundDetector
onready var ceiling_detector = $CeilingDetector
onready var ceiling_collider = $CeilingCollider


func _ready():
	if Global.editing_level:
		mode = RigidBody.MODE_STATIC
	else:
		mode = RigidBody.MODE_RIGID
		apply_central_impulse(Vector3(rand_range(-4, 4), rand_range(-4, 4), rand_range(-4, 4)))


func _physics_process(delta):
	var player_distance = Global.player.global_transform.origin - global_transform.origin
	#print(ceiling_detector.is_colliding())
	if ceiling_detector.is_colliding():
		if ceiling_collider.is_colliding() and !ground_detector.is_colliding():
			apply_central_impulse(player_distance/20)
		
		if ground_detector.is_colliding():
			apply_central_impulse(Vector3(rand_range(-4, 4), 10/linear_velocity.y, rand_range(-4, 4)))
	
	else:
		if ground_detector.is_colliding():
			apply_central_impulse(player_distance * Vector3(0.2, 1, 0.2))
