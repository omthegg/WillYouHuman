extends Node3D

@export var range:float = 100.0
@export var for_player:bool = false

@onready var raycast:RayCast3D = $RayCast3D

func _ready() -> void:
	raycast.target_position.z = -range


func _physics_process(_delta):
	if for_player and visible:
		if Input.is_action_just_pressed("left_click"):
			shoot()

 
func shoot() -> void:
	var collider:Node3D = raycast.get_collider()
	#print(collider)
	if !collider:
		return
	
	var health_component:Node = collider.get_node_or_null("HealthComponent")
	if !health_component:
		return
	
	health_component.damage()
