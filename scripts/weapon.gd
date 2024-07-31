extends Node2D

var rs_look: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physic_process(delta):
	rotate_weapon(delta)
	pass
	

func rotate_weapon(delta):
	var aim_dir: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if aim_dir.length() > .9:
		print(aim_dir.length())
		global_rotation = rotate_toward(global_rotation, aim_dir.angle(), 2 * delta)
	#rs_look.y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	#rs_look.x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	#rotation = rs_look.angle()
	pass
