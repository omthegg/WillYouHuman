extends Button

export var menu_left:bool = false
export var menu_right:bool = false
export var grandparent_menu:NodePath
export var parent_menu:NodePath
export var child_menu:NodePath

# Parent and grandparent are relative to the button,
# not the menu that the button is in.

func _on_PauseMenuButton_pressed():
	if menu_left:
		Global.player.pause_menu.menu_left()
		Global.player.pause_menu.enable_menu(get_node(grandparent_menu))
		get_node(parent_menu).hide()
	if menu_right:
		Global.player.pause_menu.menu_right()
		Global.player.pause_menu.disable_menu(get_node(parent_menu))
		get_node(child_menu).show()
