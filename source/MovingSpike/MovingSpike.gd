extends KinematicBody

export var speed:float = 1000.0
export var direction:Vector3 = Vector3(0, 0, -1)

var velocity:Vector3 = Vector3()

func _ready():
	if !Global.editing_level:
		velocity = direction * speed

func _physics_process(delta):
	if !Global.editing_level:
		move_and_slide(velocity * delta, Vector3.UP)


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.die()


func _on_Up_body_entered(body):
	if !Global.editing_level:
		if !body.is_in_group("Player") and body != self:
			if velocity.y > 0:
				velocity.y *= -1


func _on_Down_body_entered(body):
	if !Global.editing_level:
		if !body.is_in_group("Player") and body != self:
			if velocity.y < 0:
				velocity.y *= -1


func _on_Left_body_entered(body):
	if !Global.editing_level:
		if !body.is_in_group("Player") and body != self:
			if velocity.x < 0:
				velocity.x *= -1


func _on_Right_body_entered(body):
	if !Global.editing_level:
		if !body.is_in_group("Player") and body != self:
			if velocity.x > 0:
				velocity.x *= -1


func _on_Back_body_entered(body):
	if !Global.editing_level:
		if !body.is_in_group("Player") and body != self:
			if velocity.z > 0:
				velocity.z *= -1


func _on_Front_body_entered(body):
	if !Global.editing_level:
		if !body.is_in_group("Player") and body != self:
			if velocity.z < 0:
				velocity.z *= -1
