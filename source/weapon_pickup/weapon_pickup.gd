extends StaticBody3D

@onready var weapon_display:Node3D = $WeaponDisplay

const SPIN_SPEED:float = 20.0

func _physics_process(delta:float) -> void:
	weapon_display.rotate_y(deg_to_rad(SPIN_SPEED)*delta)
	if weapon_display.rotation_degrees.y > 360.0:
		weapon_display.rotation_degrees.y -= 360.0


func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.set_weapon(0)
		$Area3D/CollisionShape3D.disabled = true
