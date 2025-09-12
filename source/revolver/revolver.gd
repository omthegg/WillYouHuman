extends Node3D

@onready var animation_player:AnimationPlayer = $AnimationPlayer

func _on_hitscan_component_shot():
	animation_player.play("RESET")
	animation_player.play("shoot")
