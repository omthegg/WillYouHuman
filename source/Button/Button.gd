extends Spatial

export var one_time_press:bool = false

export var activate_moving_spatial:NodePath
export var load_scene:String
export var spawn_character:PackedScene
export var character_position:Vector3

export(int, -1, 1) var change_level_lighting = -1
# -1 : no
# 0 : bright
# 1 : dark

export var change_level_wall_color:bool = false
export var new_level_wall_color:Color = Color("ffd100")

export var text:String = ""
export var wait_time:float = 0.0

var can_be_pressed = true


func show_text():
	$Label.text = text
	$Label.show()
	$TextTimer.start()
	yield($TextTimer, "timeout")
	$Label.hide()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		
		if can_be_pressed:
			$AnimationPlayer.play("press")
			
			show_text()
			
			if change_level_lighting != -1:
				Global.map.level_light = change_level_lighting
			
			if change_level_wall_color:
				Global.map.color = new_level_wall_color
			
			if wait_time > 0:
				$WaitTimer.wait_time = wait_time
				$WaitTimer.start()
				yield($WaitTimer, "timeout")
			
			if activate_moving_spatial:
				var a = get_node(activate_moving_spatial)
				
				if a.at_point1:
					a.activate()
				elif a.at_point2:
					if !a.repeat:
						a.activate_backwards()
			
			elif load_scene != "":
				SceneTransition.transition("Smiley Minigame", load_scene)
			
			elif spawn_character:
				var character_instance = spawn_character.instance()
				Global.map.add_child(character_instance)
				character_instance.global_transform.origin = character_position
			
		
		
		if one_time_press:
			can_be_pressed = false


func _on_Area_body_exited(body):
	if !one_time_press:
		if body.is_in_group("Player"):
			$AnimationPlayer.play_backwards("press")
