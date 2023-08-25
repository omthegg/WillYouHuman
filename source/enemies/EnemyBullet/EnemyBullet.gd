extends Spatial

var predicts_player_movement = true
var velocity = Vector3()
var speed = 60.0

func _ready():
	pass
	#set_velocity()

func set_velocity():
	if predicts_player_movement:
		var distance = global_transform.origin.distance_to(Global.player.global_transform.origin)
		var t = distance / speed
		var intercept_position = Global.player.global_transform.origin + Global.player.move_vel * t
		
		look_at(intercept_position, Vector3.UP)
		velocity = -global_transform.basis.z


func _physics_process(delta):
	global_transform.origin += velocity * speed * delta
	
	if Input.is_action_just_pressed("f"):
		set_velocity()


func _on_Area_body_entered(body):
	if !body.is_in_group("Enemy"):
		queue_free()


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("Player"):
		if !Global.god_mode:
			body.damage()
		queue_free()
