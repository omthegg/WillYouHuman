extends Spatial

export var repeat:bool = false
export var activate_on_start:bool = false
export var duration:float = 3.0

export var navmesh:NodePath
export var rebake_navmesh:bool = false

onready var point1 = $Point1
onready var point2 = $Point2
onready var moving_spatial = $MovingSpatial
onready var tween = $Tween

var at_point1 = false
var at_point2 = false

var velocity:Vector3

var player_on_spatial = false # Is the player on the platform?

func _ready():
	#point1.set_as_toplevel(true)
	#point2.set_as_toplevel(true)
	moving_spatial.global_transform.origin = point1.global_transform.origin
	at_point1 = true
	
	velocity = point2.global_transform.origin - point1.global_transform.origin
	velocity /= duration
	
	print(velocity)
	
	if activate_on_start:
		activate()


func activate():
	if player_on_spatial:
		Global.player.moving_spatial_velocity = velocity
	
	at_point1 = false
	tween.interpolate_property(moving_spatial, "global_transform:origin", point1.global_transform.origin, point2.global_transform.origin, duration)
	tween.start()
	yield(tween, "tween_completed")
	at_point2 = true
	
	if rebake_navmesh:
		if navmesh:
			get_node(navmesh).bake()
	
	if player_on_spatial:
		Global.player.moving_spatial_velocity = Vector3.ZERO
	
	if repeat:
		activate_backwards()

func activate_backwards():
	if player_on_spatial:
		Global.player.moving_spatial_velocity = -velocity
	
	at_point2 = false
	tween.interpolate_property(moving_spatial, "global_transform:origin", point2.global_transform.origin, point1.global_transform.origin, duration)
	tween.start()
	yield(tween, "tween_completed")
	at_point1 = true
	
	if rebake_navmesh:
		if navmesh:
			get_node(navmesh).bake()
	
	if player_on_spatial:
		Global.player.moving_spatial_velocity = Vector3.ZERO
	
	if repeat:
		activate()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		#body.moving_spatial_velocity = velocity
		player_on_spatial = true


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		body.moving_spatial_velocity = Vector3.ZERO
		player_on_spatial = false


