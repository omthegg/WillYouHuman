tool
extends Control

class_name MultiOptionSwitch

export var options:PoolStringArray = [] setget set_options
export var current_option:int = 0 setget set_current_option

var label = Label.new()
var left_arrow = TextureButton.new()
var right_arrow = TextureButton.new()

var triangle_texture = preload("res://assets/images/custom/misc/triangle.png")
var font_data = preload("res://assets/fonts/PressStart2P-Regular.ttf")

signal value_changed(new_value)

func _ready():
	self.connect("resized", self, "resized")
	
	add_child(left_arrow)
	add_child(right_arrow)
	add_child(label)
	
	left_arrow.connect("pressed", self, "_on_LeftArrow_pressed")
	right_arrow.connect("pressed", self, "_on_RightArrow_pressed")
	
	left_arrow.texture_normal = triangle_texture
	left_arrow.texture_hover = triangle_texture
	left_arrow.texture_pressed = triangle_texture
	left_arrow.expand = true
	
	right_arrow.texture_normal = triangle_texture
	right_arrow.texture_hover = triangle_texture
	right_arrow.texture_pressed = triangle_texture
	right_arrow.expand = true
	
	left_arrow.rect_size = Vector2(16, 16)
	left_arrow.rect_pivot_offset = Vector2(8, 8)
	left_arrow.rect_rotation = -90
	
	right_arrow.rect_size = Vector2(16, 16)
	right_arrow.rect_pivot_offset = Vector2(8, 8)
	right_arrow.rect_rotation = 90
	
	var label_font = DynamicFont.new()
	label_font.font_data = font_data
	label_font.size = 8
	
	label.set("custom_fonts/font", label_font)
	label.text = options[current_option]
	label.align = Label.ALIGN_CENTER
	label.valign = Label.VALIGN_CENTER
	
	left_arrow.rect_global_position = (rect_global_position + Vector2(0, rect_size.y/2) + Vector2(-24, -8))
	right_arrow.rect_global_position = (rect_global_position + Vector2(rect_size.x, rect_size.y/2) + Vector2(8, -8))
	label.rect_global_position = rect_global_position
	label.rect_size = rect_size


func _on_LeftArrow_pressed():
	current_option -= 1
	if current_option < 0:
		current_option = options.size() - 1
	
	label.text = options[current_option]
	emit_signal("value_changed", current_option)


func _on_RightArrow_pressed():
	current_option += 1
	if current_option > options.size() - 1:
		current_option = 0
	
	label.text = options[current_option]
	emit_signal("value_changed", current_option)


func resized():
	left_arrow.rect_global_position = (rect_global_position + Vector2(0, rect_size.y/2) + Vector2(-24, -8))
	right_arrow.rect_global_position = (rect_global_position + Vector2(rect_size.x, rect_size.y/2) + Vector2(8, -8))
	label.rect_global_position = rect_global_position
	label.rect_size = rect_size


func set_options(value):
	current_option = 0
	options = value
	label.text = options[current_option]


func set_current_option(value):
	current_option = value
	label.text = options[current_option]
