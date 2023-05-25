extends Spatial

var velocity = Vector3()

var speed = 50
var damage = 200
var tracer_damage = 80


func _ready():
	$Timer.start()


func start_moving():
	velocity = -global_transform.basis.z * speed


func _physics_process(delta):
	global_transform.origin += velocity * delta
	$MeshInstance.rotate(Vector3(1, 1, 1).normalized(), 10 * delta)
	

func delete():
	$MeshInstance.hide()
	velocity = Vector3.ZERO
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func _on_Area_body_entered(body):
	if !body.is_in_group("Player"):
		if body.is_in_group("Enemy"):
			body.damage(damage)
		
		delete()


func _on_Radius_body_entered(_body):
	pass # Replace with function body.




func _on_Timer_timeout():
	delete()
