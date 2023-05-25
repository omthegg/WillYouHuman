extends KinematicBody

export var speed = 20
export var health = 28

onready var nav = get_parent()

var player_found = false

var state

var can_move = true

var alive = true

enum states {
	STAND_STILL = 0,
	MOVE = 1,
	SHOOT = 2,
	MOVE_AND_SHOOT = 3,
	LOOK_FOR_PLAYER = 4
}

func _ready():
	$Timer.start()

func _physics_process(delta):
	# Looking at the player
	var look = Global.player.global_transform.origin
	look.y = global_transform.origin.y
	
	var head_look = Global.player.global_transform.origin
	head_look.y += 0.7
	
	var hand_look = Global.player.global_transform.origin
	hand_look += $Model.global_transform.basis.x / 2
	hand_look.y += 0.7
	
	$Model.look_at(look, Vector3.UP)
	$Model/HeadJoint.look_at(head_look, Vector3.UP)
	$Model/RightArmJoint.look_at(hand_look, Vector3.UP)
	
	
	if $NavigationAgent.is_navigation_finished() or Global.player.health == 0 or !can_move:
		$Model/AnimationPlayer.stop()
		$Model/AnimationPlayer.play("RESET")
		return
	else:
		$Model/AnimationPlayer.play("Walking")
	
	var direction = Vector3(0, 0, 0)
	
	if can_move:
		if randi() % int(Engine.get_frames_per_second()) == 0:
			if $Model/HeadJoint/PlayerDetector.is_colliding():
				if $Model/HeadJoint/PlayerDetector.get_collider().is_in_group("Player"):
					shoot()
		else:
			direction = $NavigationAgent.get_next_location() - global_transform.origin
	
	var velocity = direction.normalized() * speed * 100 * delta
	$NavigationAgent.set_velocity(velocity)
	
	var _v = move_and_slide(velocity, Vector3.UP)


func move_to(target_pos):
	$NavigationAgent.set_target_location(target_pos)


func _on_Timer_timeout():
	move_to(Global.player.global_transform.origin)
	$Timer.start()


func damage(value):
	health -= value
	if health <= 0 and alive:
		die()


func die():
	alive = false
	var gib_instance = Global.guard_gib.instance()
	Global.map.add_child(gib_instance)
	gib_instance.global_transform.origin = global_transform.origin
	gib_instance.gib()
	queue_free()


func shoot():
	can_move = false
	$ShootTimer.start()
	yield($ShootTimer, "timeout")
	
	var bullet_instance = Global.enemy_bullet.instance()
	Global.map.add_child(bullet_instance)
	bullet_instance.global_transform.origin = $Model/RightArmJoint/ShootingPosition.global_transform.origin
	bullet_instance.set_velocity()
	
	$ShootTimer.start()
	yield($ShootTimer, "timeout")
	can_move = true
