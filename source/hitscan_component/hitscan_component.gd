extends Node3D

signal shot

@export var bullet_range:float = 100.0
@export var for_player:bool = false

@onready var raycast:RayCast3D = $RayCast3D

func _ready() -> void:
	raycast.target_position.z = -bullet_range


func _physics_process(_delta):
	if for_player and get_parent().visible:
		raycast.global_position = Global.scene_manager.current_level.player.camera.global_position
		raycast.global_rotation = Global.scene_manager.current_level.player.camera.global_rotation
		#print(raycast.get_collider())
		if Input.is_action_just_pressed("left_click"):
			shoot()

 
func shoot() -> void:
	emit_signal("shot")
	
	var collider:Node3D = raycast.get_collider()
	#print(collider)
	if !collider:
		return
	
	var health_component:Node = collider.get_node_or_null("HealthComponent")
	if !health_component:
		return
	
	health_component.damage()
