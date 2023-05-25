extends Control
class_name Group

var group_name:String
var label:Label = Label.new()
var delete_button:Button = Button.new()

func _ready():
	rect_min_size = Vector2(192, 20)
	add_child(label)
	label.rect_min_size = Vector2(172, 20)
	add_child(delete_button)
	delete_button.rect_position = Vector2(172, 0)
	delete_button.rect_min_size = Vector2(20, 20)
	delete_button.text = "x"
	
	yield(get_tree(), "idle_frame")
	label.text = group_name

func _process(_delta):
	if delete_button.pressed:
		Global.level_editor.selected_object.remove_from_group(group_name)
		queue_free()
