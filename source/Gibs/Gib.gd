extends Spatial

var force = 1000

func gib():
	for i in get_children():
		if i is RigidBody:
			i.apply_central_impulse(Vector3(rand_range(-force, force), rand_range(-force, force), rand_range(-force, force)))
