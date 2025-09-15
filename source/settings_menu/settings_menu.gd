extends Control

@onready var v_box_container:VBoxContainer = $VBoxContainer

func _ready() -> void:
	add_settings_elements()


func add_settings_elements() -> void:
	for key in Settings.settings:
		var h_box_container:HBoxContainer = HBoxContainer.new()
		h_box_container.name = key
		v_box_container.add_child(h_box_container, true)
		
		var label:Label = Label.new()
		label.text = key.capitalize()
		h_box_container.add_child(label, true)
		
		match typeof(Settings.settings.get(key)):
			TYPE_BOOL:
				h_box_container.add_child(create_checkbox(key), true)
			TYPE_FLOAT:
				h_box_container.add_child(create_spinbox(key), true)


func create_spinbox(key:String) -> SpinBox:
	var spinbox:SpinBox = SpinBox.new()
	spinbox.step = 0.01
	spinbox.allow_greater = true
	spinbox.allow_lesser = true
	spinbox.value = Settings.settings.get(key)
	return spinbox


func create_checkbox(key) -> CheckBox:
	var checkbox:CheckBox = CheckBox.new()
	checkbox.button_pressed = Settings.settings.get(key)
	return checkbox


func apply_settings() -> void:
	for key in Settings.settings:
		var h_box_container:HBoxContainer = v_box_container.get_node(NodePath(str(key)))
		var value:Variant = null
		match typeof(Settings.settings.get(key)):
			TYPE_FLOAT:
				value = h_box_container.get_node("SpinBox").value
			TYPE_BOOL:
				value = h_box_container.get_node("CheckBox").button_pressed
		
		Settings.settings.set(key, value)
	
	Settings.apply_settings()


func _on_button_pressed() -> void:
	hide()
	Global.scene_manager.pause_menu.show()


func _on_apply_button_pressed() -> void:
	apply_settings()
