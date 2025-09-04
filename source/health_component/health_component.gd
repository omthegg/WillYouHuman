extends Node

signal died
signal damaged

@export var max_health:int = 1
@export var delete_parent_on_death:bool = true

var health:int = 0

func _ready() -> void:
	health = max_health


func damage() -> void:
	health -= 1
	emit_signal("damaged")
	if health <= 0:
		die()


func die() -> void:
	emit_signal("died")
	if delete_parent_on_death:
		get_parent().queue_free()
