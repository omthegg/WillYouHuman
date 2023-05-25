extends Button

class_name TemplateButton

var template:LevelEditorTemplate setget set_template

var stylebox_normal = preload("res://source/LevelEditor/TemplateButtonStyleboxNormal.tres")
var stylebox_pressed = preload("res://source/LevelEditor/TemplateButtonStyleboxPressed.tres")
var stylebox_hover = stylebox_normal

var font_data = preload("res://assets/fonts/PressStart2P-Regular.ttf")

var label = Label.new()

func _ready():
	add_to_group("EditorButton", true)
	rect_min_size = Vector2(64, 64)
	clip_text = true
	toggle_mode = true
	action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
	
	set("custom_styles/hover", stylebox_hover)
	set("custom_styles/pressed", stylebox_pressed)
	#set("custom_styles/focus", stylebox_normal)
	set("custom_styles/normal", stylebox_normal)
	
	add_child(label)
	
	var font = DynamicFont.new()
	font.font_data = font_data
	font.size = 8
	label.set("custom_fonts/font", font)
	
	label.rect_size = rect_min_size
	label.rect_position = rect_position
	label.autowrap = true
	label.align = Label.ALIGN_CENTER
	label.valign = Label.VALIGN_CENTER


func set_template(value:LevelEditorTemplate):
	template = value
	label.text = value.name
	disabled = !value.enabled

func _pressed():
	Global.level_editor.unpress_template_buttons()
	pressed = true
	Global.level_editor.selected_template = template
