extends Spatial

var can_shoot = true

var secondary_charge = 0
var max_secondary_charge = 15
var overcharge = 0

var max_charge = 100
var charge = max_charge # Acts like ammo, regenerates over time
var can_charge = true

var charge_shot_impact = preload("res://source/guns/revolver/ChargeShotImpact.tscn")
var cosmetic_projectile = preload("res://source/CosmeticProjectile/CosmeticProjectile.tscn")


var normal_shot_cost = 6

var min_charge_shot = 4


var normal_damage = 14


func shoot():
	if Global.player.health > 0:
		if can_shoot and secondary_charge == 0 and charge >= normal_shot_cost:
			$AnimationPlayer.stop()
			#yield(get_tree(), "idle_frame")
			$AnimationPlayer.play("shoot")
			
			if secondary_charge == 0:
				Global.player.shooting_animation.stop()
				Global.player.shooting_animation.play("ShootRevolver")
			
			$Particles.emitting = true
			can_shoot = false
			Global.player.shake_camera(0.7)
			$Timer.start()
			charge -= normal_shot_cost
			
			# Spawning the cosmetic projectile
			#var cp = cosmetic_projectile.instance()
			#Global.map.add_child(cp)
			#cp.global_transform = $ProjectilePosition.global_transform
			
			
			# Checking for collision
			if Global.player.revolver_raycast.is_colliding():
				var collider = Global.player.revolver_raycast.get_collider()
				if collider.is_in_group("Enemy"):
					collider.damage(normal_damage)
				elif collider.is_in_group("EnemyHitbox"):
					collider.get_parent().damage(normal_damage)
				
				#00daff
				var si = Global.shot_impact.instance()
				Global.map.add_child(si)
				si.set_color(Color("00daff"))
				si.global_transform.origin = Global.player.revolver_raycast.get_collision_point()
				si.emit()
			
			$NormalShotSFX.play()
			


func charge_shot(delta):
	if Global.player.health > 0:
		if Global.player.selected_weapon == Global.player.Weapons.WEAPON_REVOLVER:
			if can_shoot and charge == max_charge:
				if Input.is_action_pressed("charge_shoot"):
					if secondary_charge < max_secondary_charge:
						secondary_charge += delta * 9#3.5
					elif secondary_charge > max_secondary_charge:
						secondary_charge = max_secondary_charge
					elif secondary_charge == max_secondary_charge:
						overcharge += delta * 6#3.5
					
					
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
					
					#if Input.is_action_just_pressed("shoot"):
					#	$ChargeParticles.emitting = false
					#	secondary_charge = 0
				
				
				if Input.is_action_just_released("charge_shoot"):
					$ChargeParticles.emitting = false
					if secondary_charge > min_charge_shot:
						#print('fire!')
						Global.player.shake_camera(secondary_charge / 10, 1)
						Global.player.head.rotation_degrees.x += secondary_charge / 1.5
						$AnimationPlayer.play("charge_shoot")
						
						charge -= (secondary_charge / max_secondary_charge) * 100
						
						if Global.player.revolver_raycast.is_colliding():
							#var collider = Global.player.revolver_raycast.get_collider()
							#if collider.is_in_group("Enemy"):
							#	collider.damage(secondary_charge * 6)
							#elif collider.is_in_group("EnemyHitbox"):
							#	collider.get_parent().damage(secondary_charge * 6)
							
							if secondary_charge > 6:
								var impact_pos = Global.player.revolver_raycast.get_collision_point()
								var impact_instance = charge_shot_impact.instance()
								Global.map.add_child(impact_instance)
								
								Global.player.get_node("Head/Camera/GunCamera/ShootingAnimation").play("ShootRevolver")
								
								impact_instance.global_transform.origin = impact_pos
								impact_instance.size = secondary_charge / 2
								impact_instance.damage = secondary_charge * 2
								impact_instance.blast()
								overcharge = 0
					
					
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
			charge += delta * 8
	elif charge > max_charge:
		charge = max_charge
	
	charge_shot(delta)



func _on_Timer_timeout():
	$Particles.emitting = false
	can_shoot = true


func _on_BurnoutTimer_timeout():
	can_charge = true
