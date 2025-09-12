extends StaticBody3D

@export var weapon:int = 1

@onready var weapon_display:Node3D = $WeaponDisplay
@onready var revolver:MeshInstance3D = $WeaponDisplay/Revolver

const SPIN_SPEED:float = 150.0

func _ready() -> void:
	if !Global.is_in_level_editor(self):
		$Outline.hide()
		match weapon:
			0:
				revolver.hide()
			1:
				revolver.show()


func _physics_process(delta:float) -> void:
	weapon_display.rotate_y(deg_to_rad(SPIN_SPEED)*delta)
	if weapon_display.rotation_degrees.y > 360.0:
		weapon_display.rotation_degrees.y -= 360.0


func _on_area_3d_body_entered(body) -> void:
	if !visible:
		return
	
	if !body.is_in_group("player"):
		return
	
	body.set_weapon(1)
	$Area3D/CollisionShape3D.disabled = true
	hide()
