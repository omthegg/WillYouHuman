extends Node2D

onready var bar1 = $Bar1
onready var bar2 = $Bar2
onready var bar3 = $Bar3

onready var player = get_parent().get_parent()

var previous_health = 3

var original_position:Vector2

func _ready():
	original_position = position

# Update the health bar visuals
func update_healthbar():
	if player.health == 3:
		bar1.modulate = Color.white
		bar2.modulate = Color.white
		bar3.modulate = Color.white
	elif player.health == 2:
		bar1.modulate = Color.white
		bar2.modulate = Color.white
		bar3.modulate = Color('2a2a2a')
		#modulate = Color.white
	elif player.health == 1:
		bar1.modulate = Color('ef1a13')
		bar2.modulate = Color('2a2a2a')
		bar3.modulate = Color('2a2a2a')
	else:
		bar1.modulate = Color('2a2a2a')
		bar2.modulate = Color('2a2a2a')
		bar3.modulate = Color('2a2a2a')
	
	# Shake the health bar if the player's health has changed
	if player.health != previous_health:
		for _i in range(15):
			position = Vector2(rand_range(-10, 10), rand_range(-10, 10))
			if is_instance_valid(get_tree()):
				yield(get_tree(), "idle_frame")
		
		position = original_position
	
	previous_health = player.health
