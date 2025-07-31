extends CSGBox3D

# ST stands for SizeTool
@onready var st_xp:Node3D = $SizeToolXP
@onready var st_xn:Node3D = $SizeToolXN
@onready var st_yp:Node3D = $SizeToolYP
@onready var st_yn:Node3D = $SizeToolYN
@onready var st_zp:Node3D = $SizeToolZP
@onready var st_zn:Node3D = $SizeToolZN

@onready var middle_x:Vector3 = (st_xp.global_position + st_xn.global_position)/2
@onready var middle_y:Vector3 = (st_yp.global_position + st_yn.global_position)/2
@onready var middle_z:Vector3 = (st_zp.global_position + st_zn.global_position)/2

@onready var previous_middle_x:Vector3 = (st_xp.global_position + st_xn.global_position)/2
@onready var previous_middle_y:Vector3 = (st_yp.global_position + st_yn.global_position)/2
@onready var previous_middle_z:Vector3 = (st_zp.global_position + st_zn.global_position)/2

var middle_x_difference:Vector3 = Vector3.ZERO
var middle_y_difference:Vector3 = Vector3.ZERO
var middle_z_difference:Vector3 = Vector3.ZERO

func _physics_process(_delta):
	var distance_x:float = st_xp.global_position.distance_to(st_xn.global_position)
	var distance_y:float = st_yp.global_position.distance_to(st_yn.global_position)
	var distance_z:float = st_zp.global_position.distance_to(st_zn.global_position)
	#global_position = middle
	size.x = distance_x
	size.y = distance_y
	size.z = distance_z
	
	if size.x == 0:
		size.x = 2
	if size.y == 0:
		size.y = 2
	if size.z == 0:
		size.z = 2
	
	set_middles()
	
	middle_x_difference = middle_x - previous_middle_x
	middle_y_difference = middle_y - previous_middle_y
	middle_z_difference = middle_z - previous_middle_z
	
	if (middle_x_difference + middle_y_difference + middle_z_difference) != Vector3.ZERO:
		global_position += middle_x_difference + middle_y_difference + middle_z_difference
		reset_size_tools()
		set_middles()
	
	set_previous_middles()


func set_middles() -> void:
	middle_x = (st_xp.global_position + st_xn.global_position)/2
	middle_y = (st_yp.global_position + st_yn.global_position)/2
	middle_z = (st_zp.global_position + st_zn.global_position)/2

func set_previous_middles() -> void:
	previous_middle_x = middle_x
	previous_middle_y = middle_y
	previous_middle_z = middle_z


func reset_size_tools() -> void:
	st_xp.global_position = global_position + Vector3(size.x/2, 0, 0)
	st_xn.global_position = global_position + Vector3(-size.x/2, 0, 0)
	st_yp.global_position = global_position + Vector3(0, size.y/2, 0)
	st_yn.global_position = global_position + Vector3(0, -size.y/2, 0)
	st_zp.global_position = global_position + Vector3(0, 0, size.z/2)
	st_zn.global_position = global_position + Vector3(0, 0, -size.z/2)
