extends RigidBody

onready var ground_detector = $GroundDetector
onready var ceiling_detector = $CeilingDetector


func _ready():
	if Global.editing_level:
		mode = RigidBody.MODE_STATIC
	else:
		mode = RigidBody.MODE_RIGID
		apply_central_impulse(Vector3(rand_range(-4, 4), rand_range(-4, 4), rand_range(-4, 4)))


func _integrate_forces(state):
	if state.get_contact_count() > 0:
		var player_distance = Global.player.global_transform.origin - global_transform.origin
		#print(ceiling_detector.is_colliding())
		if ceiling_detector.is_colliding() and !ground_detector.is_colliding():
			apply_central_impulse(player_distance * Vector3(1, 0, 1))
		
		if ground_detector.is_colliding():
			apply_central_impulse(Vector3(rand_range(-4, 4), 1/linear_velocity.y, rand_range(-4, 4)))
