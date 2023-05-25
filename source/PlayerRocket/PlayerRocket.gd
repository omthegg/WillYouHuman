extends RigidBody

var speed = 115
var damage = 50

var objects_near = []

func _ready():
	$ExplosionTimer.start()

func start_moving():
	apply_central_impulse(-global_transform.basis.z * speed)

func explode():
	for i in objects_near:
		if i.is_in_group("Player"):
			var impulse = i.global_transform.origin - global_transform.origin
			i.bounce += impulse * 7
		elif i.is_in_group("Enemy"):
			i.damage(damage)
	
	var explosion_instance = Global.explosion_effect.instance()
	Global.map.add_child(explosion_instance)
	explosion_instance.global_transform.origin = global_transform.origin
	explosion_instance.play()
	queue_free()

func _on_Area_body_entered(body):
	if !body.is_in_group("Player") and body != self:
		explode()


func _on_BlastRadius_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		objects_near.append(body)


func _on_BlastRadius_body_exited(body):
	if body in objects_near:
		objects_near.erase(body)


func _on_ExplosionTimer_timeout():
	explode()
