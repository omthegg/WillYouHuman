extends Control

onready var grid_container = $ScrollContainer/GridContainer
onready var sc_vscroll = $ScrollContainer.get_v_scrollbar()
onready var label = $Label
onready var text_edit = $TextEdit

var scroll_stylebox = preload("res://source/LevelEditor/Scroll.tres")
var scroll_grabber_stylebox = preload("res://source/LevelEditor/ScrollGrabber.tres")

var text_files = []

func _ready():
	get_text_files()
	add_buttons()
	
	sc_vscroll.add_stylebox_override("grabber_highlight", scroll_grabber_stylebox)
	sc_vscroll.add_stylebox_override("grabber", scroll_grabber_stylebox)
	sc_vscroll.add_stylebox_override("scroll", scroll_stylebox)
	sc_vscroll.add_stylebox_override("grabber_pressed", scroll_grabber_stylebox)


func get_text_files():
	var dir = Directory.new()
	dir.open("res://source/Documentation/Texts/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.begins_with("."):
			text_files.append(file)
	
	dir.list_dir_end()

func add_buttons():
	for text_file in text_files:
		var text_file_name = text_file.replace(".txt", "")
		var button = DocumentationButton.new()
		grid_container.add_child(button, true)
		button.name = text_file_name
		button.documentation_name = text_file_name
		button.text = text_file_name
		
		var file = File.new()
		file.open(str("res://source/Documentation/Texts/", text_file), File.READ)
		var text = file.get_as_text()
		
		button.documentation_text = text


func _on_CloseButton_pressed():
	hide()
