extends Spatial

var emitted = false

var on_screen = true

func _ready():
	var m = $MeshInstance.mesh.duplicate(true)
	$MeshInstance.mesh = m

func play():
	$Particles.emitting = true
	$AnimationPlayer.play("explode")
	emitted = true

func _process(_delta):
	if !$Particles.emitting and emitted:
		queue_free()
	
	if !$AnimationPlayer.is_playing() and !on_screen:
		queue_free()


func _on_VisibilityNotifier_screen_exited():
	on_screen = false


func _on_VisibilityNotifier_screen_entered():
	on_screen = true
