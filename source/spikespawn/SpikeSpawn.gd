extends Spatial

#onready var raycasts = [$RayCast, $RayCast2, $RayCast3, $RayCast4
#			, $RayCast5, $RayCast6, $RayCast6, $RayCast7
#			, $RayCast8, $RayCast9, $RayCast10, $RayCast11
#			, $RayCast12, $RayCast13]

#onready var raycasts = [$RayCast3, $RayCast5, $RayCast7, $RayCast9]
#onready var raycasts = [$RayCast3, $RayCast5, $RayCast7, $RayCast9]
onready var raycasts = [$RayCast3, $RayCast5, $RayCast7]
#onready var raycasts = [$RayCast3, $RayCast7]


var timer = 0.0


func _ready():
	global_transform.origin = AI.predict_player_position()
	#yield($RayCast13, "tree_entered")
	#create_spikes()
	for i in raycasts:
		i.global_transform.origin.x += rand_range(-5, 5)
		i.global_transform.origin.z += rand_range(-5, 5)


func _physics_process(delta):
	if AI.spikes_enabled:
		timer += delta
		if timer >= 0.1:
			create_spikes()
	else:
		queue_free()



func create_spikes():
	if $RayCast.is_colliding():
		var spike_instance
		
		if ($RayCast.get_collision_normal() == Vector3.UP) or ($RayCast.get_collision_normal() == Vector3.DOWN):
			spike_instance = Global.spike.instance() #Global.spike.instance()
		else:
			spike_instance = Global.new_spike.instance() #Global.spike.instance()
			
		
		Global.map.add_child(spike_instance)
		
		if !(($RayCast.get_collision_normal() == Vector3.UP) or ($RayCast.get_collision_normal() == Vector3.DOWN)):
			spike_instance.look_at(spike_instance.global_transform.origin + $RayCast.get_collision_normal(), Vector3.UP)
		
		spike_instance.global_transform.origin = $RayCast.get_collision_point()
		spike_instance.raise()
		#var spike_instance = Global.spike.instance()
		#Global.map.add_child(spike_instance)
		#spike_instance.global_transform.origin = $RayCast.get_collision_point()
		#spike_instance.raise()
	
	for i in raycasts:
		if i.is_colliding():
			var spike_instance
			
			if (i.get_collision_normal() == Vector3.UP) or (i.get_collision_normal() == Vector3.DOWN):
				spike_instance = Global.spike.instance() #Global.spike.instance()
			else:
				spike_instance = Global.new_spike.instance() #Global.spike.instance()
				
			
			Global.map.add_child(spike_instance)
			
			if !((i.get_collision_normal() == Vector3.UP) or (i.get_collision_normal() == Vector3.DOWN)):
				spike_instance.look_at(spike_instance.global_transform.origin + i.get_collision_normal(), Vector3.UP)
			
			spike_instance.global_transform.origin = i.get_collision_point()
			spike_instance.raise()
			
	
	queue_free()
