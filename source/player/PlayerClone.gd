extends KinematicBody

var wallrun_speed = 34
var normal_speed = 25
var speed_multiplier = 1
onready var speed = normal_speed
const ACCEL_DEFAULT = 20
const ACCEL_AIR = 20
onready var accel = ACCEL_DEFAULT
var normal_gravity = 40
var wallrun_gravity = 7
var gravity = normal_gravity
var normal_jump = 15
var wall_jump = 15#2
onready var jump = normal_jump

var can_wallrun = false
var jumps = 2

var cam_accel = 40
var mouse_sense = 0.15
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var bounce = Vector3()



var f_input = 0
var h_input = 0



var input = 0


var on_wall = false



enum Weapons {
	WEAPON_EMPTY = 0,
	WEAPON_REVOLVER = 1
}

var weapon_lookup = ['empty', 'revolver']

var selected_weapon = 1
var previous_weapon = 0


func _ready():
	yield(get_tree(), "idle_frame")
	for _i in range(60):
		#create_trail()
		move(get_physics_process_delta_time())


func move(delta):
	# Speeding up time
	# example on calculating how much later the player
	# will reach the clone's destination:
	# time to reach(seconds) = fast_delta / delta + 1
	# if fast_delta is delta * 2, then the player
	# will reach the clone's destination in 3 seconds
	
	#var fast_delta = delta * 6
	
	
	bounce.x = lerp(bounce.x, 0, 2 * delta)
	bounce.y = lerp(bounce.y, 0, 2 * delta)
	bounce.z = lerp(bounce.z, 0, 2 * delta)
	
	
	
	if is_on_wall() and ($WallrunLeft.is_colliding() or $WallrunRight.is_colliding()) and !is_on_floor() and can_wallrun:
		gravity = wallrun_gravity
		speed = wallrun_speed
		jump = wall_jump
		jumps = 2
		if !on_wall:
			gravity_vec.y = 5
			on_wall = true
	else:
		gravity = normal_gravity
		speed = normal_speed
		jump = normal_jump
	
		if on_wall:
			on_wall = false
			can_wallrun = false
	
	
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		jumps = 2
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity# * fast_delta
	
	if is_on_ceiling():
		velocity.y = -1
	
	
	#make it move
	#velocity = direction * speed * speed_multiplier * fast_delta# * fast_delta * 60#velocity.linear_interpolate(direction * speed * speed_multiplier, accel * fast_delta)
	#velocity = velocity.linear_interpolate(direction * speed * speed_multiplier, accel * fast_delta)
	#velocity *= 2
	
	#movement = (velocity + gravity_vec * 3 + bounce) * fast_delta
	movement = (velocity + gravity_vec * 3 + bounce) * delta
	
	
	var _v = move_and_slide_with_snap(movement, snap, Vector3.UP)


#func _physics_process(delta):
#	pass
#	# Speeding up time
#	# example on calculating how much later the player
#	# will reach the clone's destination:
#	# time to reach(seconds) = fast_delta / delta + 1
#	# if fast_delta is delta * 2, then the player
#	# will reach the clone's destination in 3 seconds
#
#	var fast_delta = delta * 6
#
#
#	bounce.x = lerp(bounce.x, 0, 2 * fast_delta)
#	bounce.y = lerp(bounce.y, 0, 2 * fast_delta)
#	bounce.z = lerp(bounce.z, 0, 2 * fast_delta)
#
#
#
#	if is_on_wall() and ($WallrunLeft.is_colliding() or $WallrunRight.is_colliding()) and !is_on_floor() and can_wallrun:
#		gravity = wallrun_gravity
#		speed = wallrun_speed
#		jump = wall_jump
#		jumps = 2
#		if !on_wall:
#			gravity_vec.y = 5
#			on_wall = true
#	else:
#		gravity = normal_gravity
#		speed = normal_speed
#		jump = normal_jump
#
#		if on_wall:
#			on_wall = false
#			can_wallrun = false
#
#
#
#	#jumping and gravity
#	if is_on_floor():
#		snap = -get_floor_normal()
#		accel = ACCEL_DEFAULT
#		jumps = 2
#		gravity_vec = Vector3.ZERO
#	else:
#		snap = Vector3.DOWN
#		accel = ACCEL_AIR
#		gravity_vec += Vector3.DOWN * gravity# * fast_delta
#
#	if is_on_ceiling():
#		velocity.y = -1
#
#
#	#make it move
#	#velocity = direction * speed * speed_multiplier * fast_delta# * fast_delta * 60#velocity.linear_interpolate(direction * speed * speed_multiplier, accel * fast_delta)
#	#velocity = velocity.linear_interpolate(direction * speed * speed_multiplier, accel * fast_delta)
#	#velocity *= 2
#
#	movement = (velocity + gravity_vec * 3 + bounce) * fast_delta
#
#
#
#	var _v = move_and_slide_with_snap(movement, snap, Vector3.UP)
#


# Function for creating the white trail
func create_trail():
	var trail = Global.trail.instance()
	Global.map.add_child(trail)
	trail.global_transform.origin = $TrailPosition.global_transform.origin



func _exit_tree():
	if Global.player.health > 0 and AI.spikes_enabled and AI.player_moved:
		AI.player_destination = global_transform.origin
		var spike_spawn_instance = Global.spike_spawn.instance()
		Global.map.call_deferred("add_child", spike_spawn_instance)
	
