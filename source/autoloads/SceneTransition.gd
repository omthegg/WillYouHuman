extends Sprite

var color_rect = ColorRect.new()
var tween = Tween.new()
var label = Label.new()

var font = preload("res://assets/fonts/PressStart2P-Regular.ttf")

var transitioning = false

func _ready():
	add_child(color_rect)
	add_child(tween)
	add_child(label)
	
	color_rect.color = Color.black
	modulate.a = 0
	color_rect.rect_size = Vector2(1024, 600)
	
	label.rect_size = Vector2(1024, 600)
	label.align = Label.ALIGN_CENTER
	label.valign = Label.VALIGN_CENTER
	#label.add_font_override("scene_transition_font", font)
	
	var d = DynamicFont.new()
	d.font_data = font
	label.set("custom_fonts/font", d)
	label.set("custom_fonts/settings/size", 56)
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	color_rect.pause_mode = Node.PAUSE_MODE_PROCESS
	tween.pause_mode = Node.PAUSE_MODE_PROCESS
	label.pause_mode = Node.PAUSE_MODE_PROCESS
	
	z_index = 2


# Function for transitioning to a scene
func transition(text:String="Transition", scene_path:String=""):
	if !ResourceLoader.exists(scene_path): # Checks if the level file exists
		return ERR_DOES_NOT_EXIST
	
	transitioning = true
	
	label.text = text
	get_tree().paused = true
	
	tween.interpolate_property(self, "modulate:a", 0, 1, 0.5)
	tween.start()
	yield(tween, "tween_completed")
	modulate.a = 1
	
	var _c = get_tree().change_scene(scene_path)
	
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.5)
	tween.start()
	yield(tween, "tween_completed")
	modulate.a = 0
	
	transitioning = false
	#if !paused:
	get_tree().paused = false
	
	yield(get_tree(), "idle_frame")
	Global.map.spawn_entities()
