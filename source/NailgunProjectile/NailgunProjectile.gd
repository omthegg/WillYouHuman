extends Area

var speed = 110
var damage = 10

func _physics_process(delta):
	global_transform.origin += -global_transform.basis.z * speed * delta

func _on_Area_body_entered(body):
	if !body.is_in_group("Player"):
		if body.is_in_group("Enemy"):
			body.damage(damage)
		
		#var particles = Global.create_particles(global_transform.origin, Vector3(0, -20, 0), Vector2(0.4, 0.4))
		
		queue_free()


func _on_Timer_timeout():
	queue_free()