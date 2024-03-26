extends Control

onready var player = get_parent()

onready var menu_tween = $Menu/Tween

onready var normal_menu_position = $Menu.position

func _input(_event):
	if player.health > 0 and !SceneTransition.transitioning and !Global.console_open:
		if Input.is_action_just_pressed("pause"):
			if Global.playing_custom_level:
				Global.level_editor.pause_mode = PAUSE_MODE_INHERIT
				Global.level_editor.reset()
				
			else:
				reset_menu()
				
				get_tree().paused = !get_tree().paused
				visible = !visible
				
				if visible:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#if Input.is_action_just_pressed("fullscreen"):
	#	if !$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Resolution/ResolutionMenu.visible:
	#		$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Resolution.disabled = !$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Resolution.disabled


func _ready():
	hide()
	reset_menu()


func reset_menu():
	$Menu.position = normal_menu_position
	$Menu/Settings/SettingsMenu.hide()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu.hide()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/PostProcessing/PostProcessingMenu.hide()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Skybox/SkyboxMenu.hide()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Fog/FogMenu.hide()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/FOV/FOVMenu.hide()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Rendering/RenderingMenu.hide()
	$Menu/Settings/SettingsMenu/Controls/ControlsMenu.hide()
	$Menu/Settings/SettingsMenu/Controls/ControlsMenu/MouseSensitivity/MouseSensitivityMenu.hide()
	
	enable_menu($Menu)
	enable_menu($Menu/Settings/SettingsMenu)
	enable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)
	enable_menu($Menu/Settings/SettingsMenu/Controls/ControlsMenu)


# Enables all buttons in the given menu
func enable_menu(menu:Object):
	for i in menu.get_children():
		if i is Button:
			i.disabled = false


# Disables all buttons in the given menu
func disable_menu(menu:Object):
	for i in menu.get_children():
		if i is Button:
			i.disabled = true



# Moves the menu to the right by 176 pixels
func menu_left():
	#$Menu.position.x += 176
	menu_tween.interpolate_property($Menu, "position:x", $Menu.position.x, $Menu.position.x + 176, 0.08)
	menu_tween.start()


# Moves the menu to the left by 176 pixels
func menu_right():
	#menu_tween.interpolate_property($Menu, "position", $Menu.position, Vector2($Menu.position.x - 176, $Menu.position.y), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	menu_tween.interpolate_property($Menu, "position:x", $Menu.position.x, $Menu.position.x - 176, 0.08, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#$Menu.position.x -= 176
	menu_tween.start()



func _on_Continue_pressed():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false


func _on_Quit_pressed():
	get_tree().quit()


func _on_SwitchCamera_pressed():
	Global.map.get_node("Camera").current = true


func _on_ViewportMode_pressed():
	var vp = get_viewport()
	vp.debug_draw = (vp.debug_draw + 1 ) % 4



func _on_Settings_pressed():
	disable_menu($Menu)
	menu_right()
	
	$Menu/Settings/SettingsMenu.show()
	#$Menu.position.x -= 192


# Spaghetti warning. You can look up the buttons in the
# node system to figure out what they do.

func _on_SettingsBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu.hide()
	enable_menu($Menu)


func _on_Graphics_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu.show()
	disable_menu($Menu/Settings/SettingsMenu)


func _on_GraphicsBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu)


func _on_PostProcessing_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/PostProcessing/PostProcessingMenu.show()
	disable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)



func _on_PostProcessingBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/PostProcessing/PostProcessingMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)



func _on_PostProcessingEnabled_pressed():
	for i in Global.environments:
		i.glow_enabled = true


func _on_PostProcessingDisabled_pressed():
	for i in Global.environments:
		i.glow_enabled = false


func _on_Skybox_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Skybox/SkyboxMenu.show()
	disable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)


func _on_SkyboxBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Skybox/SkyboxMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)



func _on_SkyboxEnabled_pressed():
	# Sets the default environment background to clear color
	Global.environments[0].set_background(2)


func _on_SkyboxDisabled_pressed():
	# Sets the default environment background to sky box
	Global.environments[0].set_background(0)



func _on_Fog_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Fog/FogMenu.show()
	disable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)


func _on_FogBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Fog/FogMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)



func _on_FogEnabled_pressed():
	# Enable fog on all environments
	for i in Global.environments:
		i.fog_enabled = true


func _on_FogDisabled_pressed():
	# Disable fog on all environments
	for i in Global.environments:
		i.fog_enabled = false



func _on_FOV_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/FOV/FOVMenu.show()
	disable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)


func _on_FOVBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/FOV/FOVMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)


func _on_FOVSlider_value_changed(value):
	if value == 150:
		$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/FOV/FOVMenu/FOVLabel.text = "Why are you doing this"
	else:
		$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/FOV/FOVMenu/FOVLabel.text = str(value)
	Settings.fov = value



func _on_Rendering_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Rendering/RenderingMenu.show()
	disable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)


func _on_RenderingBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Graphics/GraphicsMenu/Rendering/RenderingMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu/Graphics/GraphicsMenu)


func _on_RenderingEnabled_pressed():
	Settings.rendering_enabled = true


func _on_RenderingDisabled_pressed():
	Settings.rendering_enabled = false


func _on_Controls_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Controls/ControlsMenu.show()
	disable_menu($Menu/Settings/SettingsMenu)


func _on_ControlsBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Controls/ControlsMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu)


func _on_MouseSensitivity_pressed():
	menu_right()
	$Menu/Settings/SettingsMenu/Controls/ControlsMenu/MouseSensitivity/MouseSensitivityMenu.show()
	disable_menu($Menu/Settings/SettingsMenu/Controls/ControlsMenu)


func _on_MouseSensitivityBack_pressed():
	menu_left()
	$Menu/Settings/SettingsMenu/Controls/ControlsMenu/MouseSensitivity/MouseSensitivityMenu.hide()
	enable_menu($Menu/Settings/SettingsMenu/Controls/ControlsMenu)


func _on_MouseSensitivitySlider_value_changed(value):
	Settings.mouse_sensitivity = value
	$Menu/Settings/SettingsMenu/Controls/ControlsMenu/MouseSensitivity/MouseSensitivityMenu/MouseSensitivityLabel.text = str(value)


func _on_Difficulty_pressed():
	menu_right()
	$Menu/Difficulty/DifficultyMenu.show()
	disable_menu($Menu)


func _on_DifficultyBack_pressed():
	menu_left()
	$Menu/Difficulty/DifficultyMenu.hide()
	enable_menu($Menu)
