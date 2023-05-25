extends Spatial

export var goes_back:bool = false # Does the door take you back?
export var next_level_path:String
export var text:String = "Next level"

var player_near = false

func _ready():
	if goes_back:
		$Next.hide()
		$Back.show()
		$KeyPromptParent/KeyPrompt/Label.text = str("F\n\nBack")
	else:
		$Next.material_override.albedo_color = Color.black


func _input(_event):
	if player_near:
		if Input.is_action_just_pressed("use"):
			if goes_back:
				pass
			else:
				if next_level_path != "":
					SceneTransition.transition(text, next_level_path)


func _physics_process(delta):
	if Global.enemy_count < 1: # Check if there are no enemies left, and change the color to pink
		$KeyPromptParent.show()
		if $Next.material_override.albedo_color != Color("ff007e"):
			$Next.material_override.albedo_color = lerp($Next.material_override.albedo_color, Color("ff007e"), delta)
		
	else:
		$KeyPromptParent.hide()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if body.health > 0:
			player_near = true
			$KeyPromptParent/KeyPrompt.show()


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		player_near = false
		$KeyPromptParent/KeyPrompt.hide()
