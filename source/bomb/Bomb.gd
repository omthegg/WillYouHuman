extends RigidBody

var time:int = 5

onready var label = $Label3D
onready var timer = $Timer
onready var circle = $Circle
onready var mesh_instance = $MeshInstance

var bodies = []

var blown_up = false

var max_health = 50.0
var health = 50.0

func _ready():
	health = max_health
	label.set_as_toplevel(true)
	if Global.editing_level:
		mode = RigidBody.MODE_STATIC
		label.hide()
	else:
		timer.start(time)
	
	#$Tween.interpolate_property($MeshInstance, "material_override:albedo_color", $MeshInstance.material_override.albedo_color, $MeshInstance.material_override.albedo_color - Color(0.1, 0.1, 0.1), 1.0, Tween.TRANS_BACK, Tween.EASE_IN)


func _process(_delta):
	label.global_transform.origin = global_transform.origin + Vector3(0, 1.3, 0)
	label.text = str(int(timer.time_left+1))


func _physics_process(_delta):
	if blown_up and !$Particles.emitting:
		queue_free()


func damage(amount):
	health -= amount
	mesh_instance.get_surface_material(0).albedo_color.g = 0.7 - ((health / max_health) * 0.7)
	#print(((health / max_health)))
	if health <= 0:
		$Timer.stop()
		explode()


func explode():
	for body in bodies:
		if body.is_in_group("Player"):
			if !Global.god_mode:
				body.damage()
				body.damage()
		if body.is_in_group("Enemy"):
			body.die()
	
	blown_up = true
	mode = RigidBody.MODE_STATIC
	$CollisionShape.disabled = true
	$MeshInstance.hide()
	$Label3D.hide()
	circle.hide()
	$Particles.emitting = true


func _on_Timer_timeout():
	explode()


func _on_Area_body_entered(body):
	if !(body in bodies):
		bodies.append(body)


func _on_Area_body_exited(body):
	if body in bodies:
		bodies.erase(body)
