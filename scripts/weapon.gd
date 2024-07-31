extends Node2D
class_name Weapon


signal weapon_fired(bullet, bullet_start_postion, bullet_direction)


@export var BulletScene: PackedScene
@onready var end_of_gun = $EndOfGun
@onready var gun_direction = $GunDirection
@onready var weapon_cooldown = $WeaponCooldown
@onready var animation_player = $AnimationPlayer


var dead_zone: float = .9
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_weapon(delta)
	#var joystick_vector = Vector2(Input.get_joystick_axis(2), Input.get_joystick_axis(3))
	pass
	
func rotate_weapon(delta):
	var aim_dir: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if aim_dir.length() > dead_zone:
		global_rotation = rotate_toward(global_rotation, aim_dir.angle(), 2 * delta)
	#rs_look.y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	#rs_look.x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	#rotation = rs_look.angle()
	pass

func shoot():
	if weapon_cooldown.is_stopped():
		var bullet_instance = BulletScene.instantiate()
		var bullet_direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		weapon_fired.emit(bullet_instance, end_of_gun.global_position, bullet_direction)
		weapon_cooldown.start()
		animation_player.play("muzzle_flash")
