extends KinematicBody

export var speed = 20

onready var nav = get_parent()

func _ready():
	$Timer.start()

func _physics_process(delta):
	if $NavigationAgent.is_navigation_finished():
		return
	
	var direction = $NavigationAgent.get_next_location() - global_transform.origin
	var velocity = direction.normalized() * speed * 100 * delta
	$NavigationAgent.set_velocity(velocity)
	
	var _v = move_and_slide(velocity, Vector3.UP)


func move_to(target_pos):
	$NavigationAgent.set_target_location(target_pos)


func _on_Timer_timeout():
	move_to(Global.player.global_transform.origin)
	$Timer.start()
