extends Node2D


@onready var current_weapon:Weapon  = $Barrel_1


var weapons: Array = []
var aim_dir: Vector2
var dead_zone: float = .9


func _ready():
	weapons = get_children()

#func initialize():
	#for weapon in weapons:
		#weapon.initialize()
		#

func get_current_weapon():
	return current_weapon

func _unhandled_input(event):
	if event.is_action_pressed("shoot") and not current_weapon.animation_player.is_playing():
		current_weapon.shoot()
	elif event.is_action_pressed("reload"):
		current_weapon.start_reload()

func get_player_aim_input(delta):
	aim_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if aim_dir.length() > dead_zone:
		var aim_angle: float = aim_dir.angle()
		current_weapon.global_rotation = rotate_toward(current_weapon.global_rotation, aim_angle, 2 * delta)
