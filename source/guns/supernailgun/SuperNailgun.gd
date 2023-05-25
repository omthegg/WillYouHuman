extends Spatial

var can_shoot = true

#var max_charge = 100
#var charge = max_charge # Acts like ammo, regenerates over time


#var normal_shot_cost = 2

#var pellet_damage = 12

var shooting_position

var shooting = false

func shoot():
	if Global.player.health > 0:
		#if charge >= normal_shot_cost:
		Global.player.shake_camera(0.1)
		
		if can_shoot:
			can_shoot = false
			#charge -= normal_shot_cost
			$Timer.start()
		
		if !shooting_position:
			shooting_position = Global.player.nailgun_projectile_position
		
		var projectile_instance = Global.nailgun_projectile.instance()
		Global.map.add_child(projectile_instance)
		projectile_instance.global_transform.origin = shooting_position.global_transform.origin
		projectile_instance.look_at(shooting_position.global_transform.origin + -shooting_position.global_transform.basis.z, Vector3.UP)
		
		#$NormalShotSFX.play()
		
		$Barrel.rotation_degrees.z += 45
		#$NormalShotSFX.play()
		#else:
		#	$Barrel.rotation_degrees.z = 0
			#$AnimationPlayer.stop(true)



func _physics_process(_delta):
	if !shooting:
		$Barrel.rotation_degrees.z = 0
		#if charge < max_charge:
		#	charge += delta * 4
		#elif charge > max_charge:
		#	charge = max_charge
		
		if Input.is_action_pressed("shoot"):
			shooting = true
	
	#charge_shot(delta)


func _input(_event):
	if Input.is_action_just_released("shoot"):
		#$AnimationPlayer.stop(true)
		$Barrel.rotation_degrees.z = 0
		shooting = false
		#print(Color.coral)


func _on_Timer_timeout():
	can_shoot = true
