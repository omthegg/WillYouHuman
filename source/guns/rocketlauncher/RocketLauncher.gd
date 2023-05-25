extends Spatial

var can_shoot = true

var secondary_charge = 0
var max_secondary_charge = 15
var overcharge = 0

var max_charge = 100
var charge = max_charge # Acts like ammo, regenerates over time
var can_charge = true


var normal_shot_cost = 25

var min_charge_shot = 15


func shoot():
	if Global.player.health > 0:
		if can_shoot and secondary_charge == 0 and charge >= normal_shot_cost:
			#$AnimationPlayer.play("shoot")
			
			if secondary_charge == 0:
				Global.player.shooting_animation.stop()
				Global.player.shooting_animation.play("ShootRocketLauncher")
			
			#$Particles.emitting = true
			can_shoot = false
			Global.player.shake_camera(0.3)
			$Timer.start()
			charge -= normal_shot_cost
			
			var rocket_instance = Global.player_rocket.instance()
			Global.map.add_child(rocket_instance)
			
			# Putting the rocket infront of the camera
			var rocket_position = Global.player.camera.global_transform.origin
			rocket_position -= Global.player.camera.global_transform.basis.z
			rocket_instance.global_transform.origin = rocket_position
			
			rocket_instance.look_at(rocket_position - Global.player.camera.global_transform.basis.z, Vector3.UP)
			rocket_instance.start_moving()
			
			#$NormalShotSFX.play()
			


func charge_shot(delta):
	if Global.player.health > 0:
		if Global.player.selected_weapon == Global.player.Weapons.WEAPON_ROCKETLAUNCHER:
			if can_shoot and charge == max_charge:
				if Input.is_action_pressed("charge_shoot"):
					if secondary_charge < max_secondary_charge:
						secondary_charge += delta * 3.5
					elif secondary_charge > max_secondary_charge:
						secondary_charge = max_secondary_charge
					elif secondary_charge == max_secondary_charge:
						overcharge += delta * 3.5
					
					
					# Exploding if the player holds the blast charge for too long
					if overcharge >= 10:
						var e = Global.explosion_effect.instance()
						Global.map.add_child(e)
						e.global_transform.origin = global_transform.origin
						e.play()
						Global.player.die()
						Global.player.bounce += Global.player.global_transform.basis.z * 100
						overcharge = 0
					
					
					$ChargeParticles.emitting = true
					Global.player.shake_camera(0.1)
					#print(secondary_charge)
					
					if Input.is_action_just_pressed("shoot"):
						$ChargeParticles.emitting = false
						secondary_charge = 0
				
				
				if Input.is_action_just_released("charge_shoot"):
					$ChargeParticles.emitting = false
					if secondary_charge >= min_charge_shot:
						#print('fire!')
						$AnimationPlayer.play("charge_shoot")
						
						charge = 0
						
						var bfg_instance = Global.bfg_projectile.instance()
						Global.map.add_child(bfg_instance)
						var bfg_position = Global.player.camera.global_transform.origin - Global.player.camera.global_transform.basis.z
						bfg_instance.global_transform.origin = bfg_position
						bfg_instance.look_at(bfg_position - Global.player.camera.global_transform.basis.z, Vector3.UP)
						bfg_instance.start_moving()
						
						Global.player.get_node("Head/Camera/GunCamera/ShootingAnimation").play("ShootRocketLauncher")
						
						overcharge = 0
						
						Global.player.shake_camera(5, 5)
						Global.player.head.rotation_degrees.x += 5
					
					
					if secondary_charge == max_secondary_charge:
						$BurnoutTimer.start()
						can_charge = false
					
					
					secondary_charge = 0
		else:
			secondary_charge = 0
			overcharge = 0
			charge -= (secondary_charge / max_secondary_charge) * 100
			$ChargeParticles.emitting = false



func _physics_process(delta):
	if charge < max_charge:
		if can_charge:
			charge += delta * 6
	elif charge > max_charge:
		charge = max_charge
	
	charge_shot(delta)



func _on_Timer_timeout():
	#$Particles.emitting = false
	can_shoot = true


func _on_BurnoutTimer_timeout():
	can_charge = true
