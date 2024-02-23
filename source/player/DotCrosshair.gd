extends Node2D

onready var player = get_parent().get_parent()

func _ready():
	set_as_toplevel(true)

func _process(_delta):
	update()

func _draw():
	if player.Weapons.WEAPON_SUPERNAILGUN in Global.unlocked_weapons:
		draw_circle(Vector2(0, 0), 3.5, Color.white)
