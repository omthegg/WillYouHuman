extends Spatial

func set_skin(skin:PlayerSkin):
	$Armature/Skeleton/BoneAttachment/head.set("material/0", skin.head_material)
	$Armature/Skeleton/BoneAttachment2/visor.set("material/0", skin.visor_material)
	$Armature/Skeleton/BoneAttachment3/arm2L.set("material/0", skin.arm2L_material)
	$Armature/Skeleton/BoneAttachment4/arm1L.set("material/0", skin.arm1L_material)
	$Armature/Skeleton/BoneAttachment5/leg2L.set("material/0", skin.leg2L_material)
	$Armature/Skeleton/BoneAttachment6/leg1L.set("material/0", skin.leg1L_material)
	$Armature/Skeleton/BoneAttachment7/arm2R.set("material/0", skin.arm2R_material)
	$Armature/Skeleton/BoneAttachment8/arm1R.set("material/0", skin.arm1R_material)
	$Armature/Skeleton/BoneAttachment9/leg2R.set("material/0", skin.leg2R_material)
	$Armature/Skeleton/BoneAttachment10/leg1R.set("material/0", skin.leg1R_material)
	$Armature/Skeleton/BoneAttachment11/body.set("material/0", skin.body_material)
	
