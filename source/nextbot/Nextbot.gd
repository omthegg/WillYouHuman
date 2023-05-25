extends KinematicBody

export var min_speed:int = 25
export var max_speed:int = 70
export var gravity:int = 30
export var health:int = 200

var speed = min_speed

var velocity = Vector3()


func _physics_process(delta):
	var look = Global.player.global_transform.origin
	look.y = global_transform.origin.y
	look_at(look, Vector3.UP)
	
	# Speeding up if the player is spotted
	$RayCast.look_at(Global.player.global_transform.origin, Vector3.UP)
	if $RayCast.is_colliding():
		if $RayCast.get_collider().is_in_group('Player'):
			if speed < max_speed:
				speed += delta * 5
			elif speed > max_speed:
				speed = max_speed
		else:
			speed = min_speed
	else:
		speed = min_speed
	
	velocity = -global_transform.basis.z * speed
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity
	
	var _v = move_and_slide(velocity * delta * 100)
	


func damage(amount:int=1):
	health -= amount
	print(health)
	if health <= 0:
		die()


func die():
	queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if body.health > 0:
			Global.player.die()
			Global.player.bounce -= $RayCast.global_transform.basis.z * 200

