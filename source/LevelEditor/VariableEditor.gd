extends GridContainer
class_name VariableEditor

var variable_name:String = ""

var spinbox:SpinBox = SpinBox.new()
var checkbox:CheckBox = CheckBox.new()
var label:Label = Label.new()
var lineedit:LineEdit = LineEdit.new()

var previous_spinbox_value:float
var previous_checkbox_value:bool
var previous_lineedit_value:String

func _ready():
	yield(get_tree(), "idle_frame")
	add_child(label, true)
	label.rect_min_size = Vector2(192, 16)
	label.rect_position = Vector2(0, 0)
	label.text = variable_name
	
	var type = typeof(get_value())
	
	if type == TYPE_BOOL:
		add_child(checkbox)
		checkbox.pressed = get_value()
	elif type == TYPE_REAL or type == TYPE_INT:
		add_child(spinbox)
		spinbox.step = 0.1
		spinbox.min_value = -100000
		spinbox.max_value = 100000
		spinbox.rect_min_size = Vector2(192, 24)
		spinbox.rect_position = Vector2(0, 24)
		
		spinbox.value = get_value()
		
		previous_spinbox_value = spinbox.value
	elif type == TYPE_STRING:
		add_child(lineedit)
		lineedit.rect_min_size = Vector2(192, 24)
		lineedit.rect_position = Vector2(0, 24)
		
		lineedit.text = get_value()
	#yield(spinbox, "ready")
	#print("E")
	#spinbox.connect("changed", self, "_on_spinbox_changed")

func _process(_delta):
	if spinbox.value != previous_spinbox_value:
		_on_spinbox_changed()
	previous_spinbox_value = spinbox.value
	
	if checkbox.pressed != previous_checkbox_value:
		_on_checkbox_pressed()
	previous_checkbox_value = checkbox.pressed
	
	if lineedit.text != previous_lineedit_value:
		_on_lineedit_text_changed()
	previous_lineedit_value = lineedit.text


func _on_spinbox_changed():
	# set("something.x") doesn't work. This is the only way I can think of right now.
	if variable_name.ends_with(".x"):
		var previous_obj_value = Global.level_editor.selected_object.get(variable_name.replace(".x", ""))
		Global.level_editor.selected_object.set(variable_name.replace(".x", ""), Vector3(spinbox.value, previous_obj_value.y, previous_obj_value.z))
	elif variable_name.ends_with(".y"):
		var previous_obj_value = Global.level_editor.selected_object.get(variable_name.replace(".y", ""))
		Global.level_editor.selected_object.set(variable_name.replace(".y", ""), Vector3(previous_obj_value.x, spinbox.value, previous_obj_value.z))
	elif variable_name.ends_with(".z"):
		var previous_obj_value = Global.level_editor.selected_object.get(variable_name.replace(".z", ""))
		Global.level_editor.selected_object.set(variable_name.replace(".z", ""), Vector3(previous_obj_value.x, previous_obj_value.y, spinbox.value))
	else:
		Global.level_editor.selected_object.set(variable_name, spinbox.value)
	
	Global.level_editor.play_button.disabled = true


func _on_checkbox_pressed():
	Global.level_editor.selected_object.set(variable_name, checkbox.pressed)
	Global.level_editor.play_button.disabled = true


func _on_lineedit_text_changed():
	Global.level_editor.selected_object.set(variable_name, lineedit.text)
	Global.level_editor.play_button.disabled = true


func get_value():
	var v = 0
	
	if variable_name.ends_with(".x"):
		v = Global.level_editor.selected_object.get(variable_name.replace(".x", "")).x
	elif variable_name.ends_with(".y"):
		v = Global.level_editor.selected_object.get(variable_name.replace(".y", "")).y
	elif variable_name.ends_with(".z"):
		v = Global.level_editor.selected_object.get(variable_name.replace(".z", "")).z
	else:
		v = Global.level_editor.selected_object.get(variable_name)
	
	return v
