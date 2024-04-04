extends Button

class_name DocumentationButton

var font = preload("res://source/Documentation/DocumentationButtonFont.tres")
var stylebox_normal = preload("res://source/Documentation/DocumentationButtonNormal.tres")
var stylebox_pressed = preload("res://source/Documentation/DocumentationButtonPressed.tres")
var stylebox_hover = preload("res://source/Documentation/DocumentationButtonHover.tres")

var documentation_name:String
var documentation_text:String

onready var documentation_tab = get_parent().get_parent().get_parent()

func _ready():
	connect("pressed", self, "_on_button_pressed")
	
	rect_min_size = Vector2(128, 40)
	rect_size = Vector2(128, 40)
	add_font_override("font", font)
	add_stylebox_override("normal", stylebox_normal)
	add_stylebox_override("pressed", stylebox_pressed)
	add_stylebox_override("hover", stylebox_hover)
	text = documentation_name

func _on_button_pressed():
	documentation_tab.label.text = documentation_name
	documentation_tab.text_edit.text = documentation_text
