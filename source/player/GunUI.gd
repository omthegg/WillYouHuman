extends Node2D

onready var player = get_parent().get_parent()

onready var weapon_blast_charge = $WeaponBlastCharge

onready var revolver_charge = $RevolverCharge
onready var revolver_icon = $RevolverIcon
onready var revolver = player.revolver

onready var shotgun_charge = $ShotgunCharge
onready var shotgun_icon = $ShotgunIcon
onready var shotgun = player.shotgun

onready var nailgun_charge = $NailgunCharge
onready var nailgun_icon = $NailgunIcon
onready var nailgun = player.nailgun

onready var rocketlauncher_charge = $RocketLauncherCharge
onready var rocketlauncher_icon = $RocketLauncherIcon
onready var rocketlauncher = player.rocketlauncher

func _ready():
	show()

func revolver_ui():
	if revolver:
		var charge_percent = ((revolver.charge/revolver.max_charge) * 100)
		#print(charge_percent)
		revolver_charge.material.set_shader_param('value', charge_percent)
		
		# Changing color based on charge
		if revolver.charge < revolver.normal_shot_cost:
			revolver_charge.modulate = Color('ef1a13')
			revolver_icon.modulate = Color('ef1a13')
		elif revolver.charge == revolver.max_charge:
			revolver_charge.modulate = Color('ff00e9')
			revolver_icon.modulate = Color('ff00e9')
		else:
			revolver_charge.modulate = Color('00daff')
			revolver_icon.modulate = Color('00daff')
		
		# Changing color based on blast charge
		if revolver.secondary_charge > 0:
			weapon_blast_charge.show()
			var p = (revolver.secondary_charge / revolver.max_secondary_charge) * 100
			weapon_blast_charge.value = p
		
		
		
		if player.selected_weapon == player.Weapons.WEAPON_REVOLVER:
			if revolver.secondary_charge < revolver.min_charge_shot:
				weapon_blast_charge.modulate = Color('ef1a13')
			elif revolver.overcharge > 5:
				# Changing color to red and shaking the weapon blast charge ui
				# when the revolver's overcharge is above 5. The revolver
				# blows up after 10.
				weapon_blast_charge.modulate = Color('ef1a13')
				shake_weapon_blast_charge()
			else:
				weapon_blast_charge.modulate = Color.white
		
		
		# Cooldown after shooting fully charged balst shot
		if revolver.can_charge:
			$RevolverCharge/CoolingDown.hide()
		else:
			$RevolverCharge/CoolingDown.show()
		
		# Opacity
		#if player.selected_weapon == player.Weapons.WEAPON_REVOLVER:
		#	revolver_charge.modulate.a = 1
		#	revolver_icon.modulate.a = 1
		#else:
		#	revolver_charge.modulate.a = 0.25
		#	revolver_icon.modulate.a = 0.25
		
		# Ammo counter
		$RevolverCharge/Label.text = str(int(revolver.charge/revolver.normal_shot_cost), "/", int(revolver.max_charge/revolver.normal_shot_cost))
		
	else:
		revolver = player.revolver



func shotgun_ui():
	if shotgun:
		var charge_percent = ((shotgun.charge/shotgun.max_charge) * 100)
		#print(charge_percent)
		shotgun_charge.material.set_shader_param('value', charge_percent)
		
		# Changing color based on charge
		if shotgun.charge < shotgun.normal_shot_cost:
			shotgun_charge.modulate = Color('ef1a13')
			shotgun_icon.modulate = Color('ef1a13')
		elif shotgun.charge == shotgun.max_charge:
			shotgun_charge.modulate = Color('ffa100')
			shotgun_icon.modulate = Color('ffa100')
		else:
			shotgun_charge.modulate = Color('ffa100')
			shotgun_icon.modulate = Color('ffa100')
		
		# Changing color based on blast charge
		#if shotgun.secondary_charge > 0:
		#	weapon_blast_charge.show()
		#	var p = (shotgun.secondary_charge / shotgun.max_secondary_charge) * 100
		#	weapon_blast_charge.value = p
		#else:
		#	weapon_blast_charge.hide()
		
		#if shotgun.secondary_charge < shotgun.min_charge_shot:
		#	weapon_blast_charge.modulate = Color('ef1a13')
		#elif shotgun.overcharge > 5:
		#	# Changing color to red and shaking the weapon blast charge ui
			# when the revolver's overcharge is above 5. The revolver
			# blows up after 10.
		#	weapon_blast_charge.modulate = Color('ef1a13')
		#	shake_weapon_blast_charge()
		#else:
		#	weapon_blast_charge.modulate = Color.white
		
		# Opacity
		#if player.selected_weapon == player.Weapons.WEAPON_SHOTGUN:
		#	shotgun_charge.modulate.a = 1
		#	shotgun_icon.modulate.a = 1
		#else:
		#	shotgun_charge.modulate.a = 0.55
		#	shotgun_icon.modulate.a = 0.55
		
		# Ammo counter
		$ShotgunCharge/Label.text = str(int(shotgun.charge/shotgun.normal_shot_cost), "/", int(shotgun.max_charge/shotgun.normal_shot_cost))
		
	else:
		shotgun = player.shotgun



func nailgun_ui():
	if nailgun:
		var charge_percent = ((nailgun.charge/nailgun.max_charge) * 100)
		#print(charge_percent)
		nailgun_charge.material.set_shader_param('value', charge_percent)
		
		# Changing color based on charge
		if nailgun.charge < nailgun.normal_shot_cost:
			nailgun_charge.modulate = Color('ef1a13')
			nailgun_icon.modulate = Color('ef1a13')
		elif nailgun.charge == nailgun.max_charge:
			nailgun_charge.modulate = Color.coral
			nailgun_icon.modulate = Color.coral
		else:
			nailgun_charge.modulate = Color.coral
			nailgun_icon.modulate = Color.coral
		
		# Changing color based on blast charge
		#if shotgun.secondary_charge > 0:
		#	weapon_blast_charge.show()
		#	var p = (shotgun.secondary_charge / shotgun.max_secondary_charge) * 100
		#	weapon_blast_charge.value = p
		#else:
		#	weapon_blast_charge.hide()
		
		#if shotgun.secondary_charge < shotgun.min_charge_shot:
		#	weapon_blast_charge.modulate = Color('ef1a13')
		#elif shotgun.overcharge > 5:
		#	# Changing color to red and shaking the weapon blast charge ui
			# when the revolver's overcharge is above 5. The revolver
			# blows up after 10.
		#	weapon_blast_charge.modulate = Color('ef1a13')
		#	shake_weapon_blast_charge()
		#else:
		#	weapon_blast_charge.modulate = Color.white
		
		# Opacity
		#if player.selected_weapon == player.Weapons.WEAPON_SHOTGUN:
		#	shotgun_charge.modulate.a = 1
		#	shotgun_icon.modulate.a = 1
		#else:
		#	shotgun_charge.modulate.a = 0.55
		#	shotgun_icon.modulate.a = 0.55
		
		# Ammo counter
		$NailgunCharge/Label.text = str(int(nailgun.charge/nailgun.normal_shot_cost), "/", int(nailgun.max_charge/nailgun.normal_shot_cost))
		
	else:
		nailgun = player.nailgun




func rocketlauncher_ui():
	if rocketlauncher:
		var charge_percent = ((rocketlauncher.charge/rocketlauncher.max_charge) * 100)
		#print(charge_percent)
		rocketlauncher_charge.material.set_shader_param('value', charge_percent)
		
		# Changing color based on charge
		if rocketlauncher.charge < rocketlauncher.normal_shot_cost:
			rocketlauncher_charge.modulate = Color('ef1a13')
			rocketlauncher_icon.modulate = Color('ef1a13')
		elif rocketlauncher.charge == rocketlauncher.max_charge:
			rocketlauncher_charge.modulate = Color.limegreen#Color('ff00e9')
			rocketlauncher_icon.modulate = Color.limegreen#Color('ff00e9')
		else:
			rocketlauncher_charge.modulate = Color.steelblue#Color('00daff')
			rocketlauncher_icon.modulate = Color.steelblue#Color('00daff')
		
		# Changing color based on blast charge
		if rocketlauncher.secondary_charge > 0:
			weapon_blast_charge.show()
			var p = (rocketlauncher.secondary_charge / rocketlauncher.max_secondary_charge) * 100
			weapon_blast_charge.value = p
		
		
		if player.selected_weapon == player.Weapons.WEAPON_ROCKETLAUNCHER:
			if rocketlauncher.secondary_charge < rocketlauncher.min_charge_shot:
				weapon_blast_charge.modulate = Color('ef1a13')
			elif rocketlauncher.overcharge > 5:
				# Changing color to red and shaking the weapon blast charge ui
				# when the revolver's overcharge is above 5. The revolver
				# blows up after 10.
				weapon_blast_charge.modulate = Color('ef1a13')
				shake_weapon_blast_charge()
			else:
				weapon_blast_charge.modulate = Color.white
		
		# Cooldown after shooting fully charged balst shot
		if rocketlauncher.can_charge:
			$RocketLauncherCharge/CoolingDown.hide()
		else:
			$RocketLauncherCharge/CoolingDown.show()
		
		# Opacity
		#if player.selected_weapon == player.Weapons.WEAPON_REVOLVER:
		#	revolver_charge.modulate.a = 1
		#	revolver_icon.modulate.a = 1
		#else:
		#	revolver_charge.modulate.a = 0.25
		#	revolver_icon.modulate.a = 0.25
		
		# Ammo counter
		$RocketLauncherCharge/Label.text = str(int(rocketlauncher.charge/rocketlauncher.normal_shot_cost), "/", int(rocketlauncher.max_charge/rocketlauncher.normal_shot_cost))
		
	else:
		rocketlauncher = player.rocketlauncher





# Function for shaking the "weapon blast charge" UI
func shake_weapon_blast_charge():
	var op = weapon_blast_charge.rect_position
	var p = weapon_blast_charge.rect_position + Vector2(rand_range(-2, 2), rand_range(-2, 2))
	weapon_blast_charge.rect_position = p
	yield(get_tree(), "idle_frame")
	weapon_blast_charge.rect_position = op


func _process(_delta):
	if player.Weapons.WEAPON_REVOLVER in Global.unlocked_weapons:
		revolver_ui()
		revolver_charge.show()
		revolver_icon.show()
	else:
		revolver_charge.hide()
		revolver_icon.hide()
	
	if player.Weapons.WEAPON_SHOTGUN in Global.unlocked_weapons:
		shotgun_ui()
		shotgun_charge.show()
		shotgun_icon.show()
	else:
		shotgun_charge.hide()
		shotgun_icon.hide()
	
	if player.Weapons.WEAPON_NAILGUN in Global.unlocked_weapons:
		nailgun_ui()
		nailgun_charge.show()
		nailgun_icon.show()
	else:
		nailgun_charge.hide()
		nailgun_icon.hide()
	
	if player.Weapons.WEAPON_ROCKETLAUNCHER in Global.unlocked_weapons:
		rocketlauncher_ui()
		rocketlauncher_charge.show()
		rocketlauncher_icon.show()
	else:
		rocketlauncher_charge.hide()
		rocketlauncher_icon.hide()
	
	if !revolver:
		revolver = player.revolver
	if !shotgun:
		shotgun = player.shotgun
	if !nailgun:
		nailgun = player.nailgun
	if !rocketlauncher:
		rocketlauncher = player.rocketlauncher
	
	
	if (revolver.secondary_charge == 0) and (rocketlauncher.secondary_charge == 0):
		weapon_blast_charge.hide()
	
