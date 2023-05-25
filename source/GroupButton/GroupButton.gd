extends StaticBody

export var trigger_group:String
#export var toggle:bool = true
#export var one_time_press:bool = true
#export var continuous_signal:bool = false
export var mode:int = 0
# 0: one_time_press
# 1: toggle
# 3: hold

var pressed = false


func _ready():
	if !Global.editing_level:
		$CollisionShape.disabled = true


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if mode == 0:
			if !pressed:
				pressed = true
				$AnimationPlayer.play("Press")
				trigger()
		elif mode == 1:
			pressed = !pressed
			if pressed:
				$AnimationPlayer.play("Press")
			else:
				$AnimationPlayer.play_backwards("Press")
		elif mode == 2:
			pressed = true
			$AnimationPlayer.play("Press")


func _physics_process(_delta):
	if pressed and (mode == 2 or mode == 1):
		trigger()


func trigger():
	for node in get_tree().get_nodes_in_group(trigger_group):
		if node.has_method("trigger"):
			node.trigger()


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		if mode == 2:
			pressed = false
			$AnimationPlayer.play_backwards("Press")
