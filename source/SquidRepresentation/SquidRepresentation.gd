extends Spatial

onready var EyebrowLeftUp = $Pivot/EyebrowLeftUp
onready var EyebrowLeftDown = $Pivot/EyebrowLeftDown
onready var EyeLeft = $Pivot/EyeLeft
onready var EyebrowRightUp = $Pivot/EyebrowRightUp
onready var EyebrowRightDown = $Pivot/EyebrowRightDown
onready var EyeRight = $Pivot/EyeRight
onready var Mouth = $Pivot/Mouth

var talking_move_speed = 10
var silent_move_speed = 5

var follow_player_speed = silent_move_speed
var distance_from_camera = 15

var talking_rotation_speed = 7
var silent_rotation_speed = 4
var rotation_speed = silent_rotation_speed

var parts_move_speed = 5

enum Emotion {
	NEUTRAL = 0,
	HAPPY = 1,
	SAD = 2,
	HORRIFIED = 3,
	PITYING = 4,
	CHEEKY = 5,
	SKEPTICAL = 6,
	ANNOYED = 7,
	MEAN = 8,
	ANGRY = 9,
	EVIL = 10,
	CRAZY = 11
}

var emotion = Emotion.NEUTRAL


class Origins:
	var eyebrow_left_up:Vector3
	var eyebrow_left_down:Vector3
	var eye_left:Vector3
	var eyebrow_right_up:Vector3
	var eyebrow_right_down:Vector3
	var eye_right:Vector3
	var mouth:Vector3


var neutral_origins = preload("res://source/SquidRepresentation/Neutral.tres")
var happy_origins = preload("res://source/SquidRepresentation/Happy.tres")
var sad_origins = preload("res://source/SquidRepresentation/Sad.tres")
var horrified_origins = preload("res://source/SquidRepresentation/Horrified.tres")
var pitying_origins = preload("res://source/SquidRepresentation/Pitying.tres")

var origins

var offset_origins

var line_texture = preload("res://assets/images/squid/sprite_2.png")
var bracket_texture = preload("res://assets/images/squid/sprite_0.png")

func _ready():
	Global.squid_representation = self
	
	set_emotion(Emotion.NEUTRAL)
	
	$Timer.start()


func _physics_process(delta):
	global_transform.origin = lerp(global_transform.origin, Global.player.global_transform.origin, follow_player_speed * Global.player.speed_multiplier * delta)
	$Pivot.translation.z = -distance_from_camera
	var target_rotation = Global.player.camera.global_transform.basis.get_euler()# + (-Global.player.camera.global_transform.basis.z * Vector3(deg2rad(20), deg2rad(40), 0))
	rotation.x = lerp_angle(rotation.x, target_rotation.x, rotation_speed * delta)
	rotation.y = lerp_angle(rotation.y, target_rotation.y, rotation_speed * delta)
	rotation.z = lerp_angle(rotation.z, target_rotation.z, rotation_speed * delta)
	
	move_face_parts(delta)
	
	if Input.is_action_pressed("f"):
		talk()
	


func set_emotion(e:int):
	emotion = e
	match e:
		0:
			origins = neutral_origins.duplicate()
			Mouth.texture = line_texture
		1:
			origins = happy_origins.duplicate()
			Mouth.texture = bracket_texture
			Mouth.flip_v = true
		2:
			origins = sad_origins.duplicate()
			Mouth.texture = bracket_texture
			Mouth.flip_v = false
		3:
			origins = horrified_origins.duplicate()
			Mouth.texture = bracket_texture
			Mouth.flip_v = false
		4:
			origins = pitying_origins.duplicate()
			Mouth.texture = bracket_texture
			Mouth.flip_v = true
	
	offset_origins = origins.duplicate()


func talk():
	$AnimationPlayer.play("talk")


func move_face_parts(delta):
	# Offset face parts
	EyebrowLeftUp.translation = lerp(EyebrowLeftUp.translation, offset_origins.eyebrow_left_up, parts_move_speed * delta)
	EyebrowLeftDown.translation = lerp(EyebrowLeftDown.translation, offset_origins.eyebrow_left_down, parts_move_speed * delta)
	EyeLeft.translation = lerp(EyeLeft.translation, offset_origins.eye_left, parts_move_speed * delta)
	
	EyebrowRightUp.translation = lerp(EyebrowRightUp.translation, offset_origins.eyebrow_right_up, parts_move_speed * delta)
	EyebrowRightDown.translation = lerp(EyebrowRightDown.translation, offset_origins.eyebrow_right_down, parts_move_speed * delta)
	EyeRight.translation = lerp(EyeRight.translation, offset_origins.eye_right, parts_move_speed * delta)
	
	Mouth.translation = lerp(Mouth.translation, offset_origins.mouth, parts_move_speed * delta)
	
	EyebrowLeftUp.rotation.z = lerp_angle(EyebrowLeftUp.rotation.z, deg2rad(origins.eyebrow_left_up_rotation), parts_move_speed * delta)
	EyebrowRightUp.rotation.z = lerp_angle(EyebrowRightUp.rotation.z, deg2rad(origins.eyebrow_right_up_rotation), parts_move_speed * delta)


func _on_Timer_timeout():
	#var offset_origins = Origins.new()
	var l = -0.2 # Lowest possible offset
	var h = 0.2 # Highest possible offset
	
	var mouth_l = -0.3
	var mouth_h = 0.3
	
	# Offset face parts
	offset_origins.eyebrow_left_up = origins.eyebrow_left_up + Vector3(rand_range(l, h), rand_range(l, h), rand_range(l, h))
	offset_origins.eyebrow_left_down = origins.eyebrow_left_down + Vector3(rand_range(l, h), rand_range(l, h), rand_range(l, h))
	print(origins.eyebrow_left_up)
	#offset_origins.eye_left = origins.eye_left + (Vector3(1, 1, 1) * rand_range(l, h))
	
	offset_origins.eyebrow_right_up = origins.eyebrow_right_up + Vector3(rand_range(l, h), rand_range(l, h), rand_range(l, h))
	offset_origins.eyebrow_right_down = origins.eyebrow_right_down + Vector3(rand_range(l, h), rand_range(l, h), rand_range(l, h))
	#offset_origins.eye_right = origins.eye_right + (Vector3(1, 1, 1) * rand_range(l, h))
	
	offset_origins.mouth = origins.mouth + Vector3(rand_range(mouth_l, mouth_h), rand_range(mouth_l, mouth_h), rand_range(mouth_l, mouth_h))
	
	$Timer.wait_time = rand_range(0.5, 0.9)
	$Timer.start()
