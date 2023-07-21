extends Control

class_name OptionSwitch

export var options:PoolStringArray = []
export var current_option:int = 0

onready var label = Label.new()
onready var left_arrow = TextureButton.new()
onready var right_arrow = TextureButton.new()

var triangle_texture = preload("res://assets/images/custom/misc/triangle.png")
var font_data = preload("res://assets/fonts/PressStart2P-Regular.ttf")

func _ready():
	add_child(left_arrow)
	add_child(right_arrow)
	add_child(label)
	
	left_arrow.connect("pressed", self, "_on_LeftArrow_pressed")
	right_arrow.connect("pressed", self, "_on_RightArrow_pressed")
	
	left_arrow.texture_normal = triangle_texture
	left_arrow.texture_hover = triangle_texture
	left_arrow.texture_pressed = triangle_texture
	
	right_arrow.texture_normal = triangle_texture
	right_arrow.texture_hover = triangle_texture
	right_arrow.texture_pressed = triangle_texture
	
	var label_font = DynamicFont.new()
	label_font.font_data = font_data
	
	label.set("custom_fonts/font", label_font)
	label.text = options[current_option]


func _on_LeftArrow_pressed():
	current_option -= 1
	if current_option < options.size():
		current_option = options.size()
	
	label.text = options[current_option]


func _on_RightArrow_pressed():
	current_option += 1
	if current_option > options.size():
		current_option = 0
	
	label.text = options[current_option]
