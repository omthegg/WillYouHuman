extends Spatial

func set_fov(value:int):
	$Armature/Skeleton/BoneAttachment/arm2L.get("material/0").set_shader_param("fov", value)
	$Armature/Skeleton/BoneAttachment2/arm1L.get("material/0").set_shader_param("fov", value)
	$Armature/Skeleton/BoneAttachment3/arm2R.get("material/0").set_shader_param("fov", value)
	$Armature/Skeleton/BoneAttachment4/arm1R.get("material/0").set_shader_param("fov", value)
	print($Armature/Skeleton/BoneAttachment/arm2L.get("material/0").get_shader_param("fov"))


func set_skin(skin:PlayerSkin):
	print($Armature/Skeleton/BoneAttachment/arm2L)
	$Armature/Skeleton/BoneAttachment/arm2L.get("material/0").set_shader_param("albedo", skin.arm2L_material.albedo_color)
	$Armature/Skeleton/BoneAttachment/arm2L.get("material/0").set_shader_param("texture_albedo", skin.arm2L_material.albedo_texture)
	
	$Armature/Skeleton/BoneAttachment2/arm1L.get("material/0").set_shader_param("albedo", skin.arm1L_material.albedo_color)
	$Armature/Skeleton/BoneAttachment2/arm1L.get("material/0").set_shader_param("texture_albedo", skin.arm1L_material.albedo_texture)
	
	$Armature/Skeleton/BoneAttachment3/arm2R.get("material/0").set_shader_param("albedo", skin.arm2R_material.albedo_color)
	$Armature/Skeleton/BoneAttachment3/arm2R.get("material/0").set_shader_param("texture_albedo", skin.arm2R_material.albedo_texture)
	
	$Armature/Skeleton/BoneAttachment4/arm1R.get("material/0").set_shader_param("albedo", skin.arm1R_material.albedo_color)
	$Armature/Skeleton/BoneAttachment4/arm1R.get("material/0").set_shader_param("texture_albedo", skin.arm1R_material.albedo_texture)
