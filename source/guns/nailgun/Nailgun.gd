extends Spatial

var can_shoot = true

var max_charge = 100
var charge = max_charge # Acts like ammo, regenerates over time


var normal_shot_cost = 2

var pellet_damage = 12

var raycast

var shooting = false

func shoot():
	if Global.player.health > 0:
		if charge >= normal_shot_cost:
			$AnimationPlayer.stop()
			$AnimationPlayer.play("shoot")
			Global.player.shake_camera(0.1)
			
			if can_shoot:
				can_shoot = false
				charge -= normal_shot_cost
				$Timer.start()
			
			if !raycast:
				raycast = Global.player.nailgun_raycast
			
			if raycast.is_colliding():
				if raycast.get_collider().is_in_group("Enemy"):
					raycast.get_collider().damage(pellet_damage)
				elif raycast.get_collider().is_in_group("EnemyHitbox"):
					raycast.get_collider().get_parent().damage(pellet_damage)
				
				var si = Global.shot_impact.instance()
				Global.map.add_child(si)
				si.set_color(Color.coral)
				si.global_transform.origin = raycast.get_collision_point()
				si.emit()
			
			$NormalShotSFX.play()
			$AnimationPlayer2.play("shoot")
		
		else:
			$Barrel.rotation_degrees.z = 0
			#$AnimationPlayer.stop(true)



func _physics_process(delta):
	if !shooting:
		if charge < max_charge:
			charge += delta * 4
		elif charge > max_charge:
			charge = max_charge
		
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
