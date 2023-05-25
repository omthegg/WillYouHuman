extends Map

onready var Smileys = $Smileys
onready var spawn_position = $SpawnPosition


var xp = 0
var lvl = 0


func _input(_event):
	if Input.is_action_just_pressed("g"):
		SceneTransition.transition("Testing Area", "res://source/maps/TestMap.tscn")

func _ready():
	$CreateTimer.start()
	$Player.arms.hide()
	$Player.can_shoot = false
	$Player.hide_hud()
	update()
	
	for _i in range(80):
		spawn_smiley()


func update():
	if xp >= 100:
		lvl += 1
		xp = xp - 100
		$LevelLabel.text = str("Level: ", lvl)
	
	$ProgressBar.value = xp


func spawn_smiley():
	var smiley_instance = Global.smiley.instance()
	Smileys.add_child(smiley_instance)
	smiley_instance.global_transform.origin = Vector3(rand_range(-100, 100), rand_range(-50, 50), rand_range(-100, 100))

func _on_CreateTimer_timeout():
	if Smileys.get_child_count() < 80:
		spawn_smiley()
	
	$CreateTimer.start()
