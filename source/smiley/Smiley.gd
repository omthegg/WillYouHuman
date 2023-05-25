extends Spatial

onready var minigame = get_node("/root/SmileyMinigame")

var WBilgini = preload("res://source/smiley/WBilgini.tres")
var PUP2 = preload("res://source/smiley/PUP2.tres")

var velocity = Vector3()
var speed = 4

var collided = false
var collected = false

var xp = 4

var special = false

var enabled = true

var colors = [
	Color.magenta,
	Color.cyan
]

func _ready():
	while (velocity > Vector3(-0.5, -0.5, -0.5) and velocity < Vector3(0.5, 0.5, 0.5)):
		velocity = Vector3(rand_range(-2, 2), rand_range(-2, 2), rand_range(-1, 1))
	
	$MeshInstance.mesh.surface_get_material(0).albedo_color = colors[randi() %2 -1]
	
	# Eastereggs
	if (randi() %2 -1) == 0:
		if (randi() %3001 -1) == 0:
			$MeshInstance.material_override = WBilgini
			special = true
	else:
		if (randi() %3001 -1) == 0:
			$MeshInstance.material_override = PUP2
			special = true
	
	$MeshInstance.hide()
	
	$AnimationPlayer.play("ready")


func _physics_process(delta):
	if $LeftCheck.is_colliding():
		velocity.x = abs(velocity.x)
	if $RightCheck.is_colliding():
		velocity.x = -abs(velocity.x)
	if $FrontCheck.is_colliding():
		velocity.z = abs(velocity.z)
	if $BackCheck.is_colliding():
		velocity.z = -abs(velocity.z)
	if $UpCheck.is_colliding():
		velocity.y = -abs(velocity.y)
	if $DownCheck.is_colliding():
		velocity.y = abs(velocity.y)
	
	var x_diff = global_transform.origin.x - Global.player.global_transform.origin.x
	var z_diff = global_transform.origin.z - Global.player.global_transform.origin.z
	var diff = Vector3(x_diff, 0, z_diff)
	
	if diff != Vector3.ZERO:
		$PlayerDetector.look_at(Global.player.global_transform.origin, Vector3.UP)
		$CollectDetector.look_at(Global.player.global_transform.origin, Vector3.UP)
	
	if $PlayerDetector.is_colliding() and !special and enabled:
		collided = true
	
	if collided:
		velocity = -$PlayerDetector.global_transform.basis.z * speed * 3
	else:
		$MeshInstance.rotation_degrees += velocity

	if $CollectDetector.is_colliding() and !special and enabled:
		minigame.xp += xp
		minigame.update()
		queue_free()
	
	global_transform.origin += velocity * delta * speed


func _on_AnimationPlayer_animation_finished(_anim_name):
	if collected:
		queue_free()
