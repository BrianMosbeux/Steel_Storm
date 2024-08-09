extends Node2D


signal weapon_changed(new_weapon)


const TANK_BLUE_BARREL_1_OUTLINE = preload("res://assets/sprites/tank_blue/tankBlue_barrel1_outline.png")
const TANK_BLUE_BARREL_2_OUTLINE = preload("res://assets/sprites/tank_blue/tankBlue_barrel2_outline.png")
const TANK_BLUE_BARREL_3_OUTLINE = preload("res://assets/sprites/tank_blue/tankBlue_barrel3_outline.png")
const TANK_RED_BARREL_1_OUTLINE = preload("res://assets/sprites/tank_red/tankRed_barrel1_outline.png")
const TANK_RED_BARREL_2_OUTLINE = preload("res://assets/sprites/tank_red/tankRed_barrel2_outline.png")
const TANK_RED_BARREL_3_OUTLINE = preload("res://assets/sprites/tank_red/tankRed_barrel3_outline.png")


@onready var current_weapon:Weapon  = $Barrel1


var weapon_sprites : = {
	Vector2i(1, 0): TANK_BLUE_BARREL_1_OUTLINE,
	Vector2i(1, 1): TANK_BLUE_BARREL_2_OUTLINE,
	Vector2i(1, 2): TANK_BLUE_BARREL_2_OUTLINE,
	Vector2i(2, 0): TANK_RED_BARREL_1_OUTLINE,
	Vector2i(2, 1): TANK_RED_BARREL_2_OUTLINE,
	Vector2i(2, 2): TANK_RED_BARREL_2_OUTLINE,
}
var weapons: Array = []
var aim_dir: Vector2
var dead_zone: float = .9


func _ready():
	weapons = get_children()
	for weapon in weapons:
		weapon.hide()
	current_weapon.show()

func initialize(team: int):
	for weapon in weapons:
		var wepon_sprite_key = Vector2i(team, weapon.get_index())
		var weapon_sprite = weapon_sprites[wepon_sprite_key]
		weapon.initialize(team, weapon_sprite)

func get_current_weapon():
	return current_weapon
	
func switch_weapon(weapon: Weapon):
	if weapon == current_weapon or current_weapon.reloading == true:
		return
	current_weapon.hide()
	weapon.show()
	current_weapon = weapon
	weapon_changed.emit(current_weapon)

func _unhandled_input(event):
	if event.is_action_pressed("shoot") and not current_weapon.animation_player.is_playing():
		current_weapon.shoot()
	elif event.is_action_pressed("reload"):
		current_weapon.start_reload()
	elif event.is_action_pressed("weapon_1"):
		switch_weapon(weapons[0])
	elif event.is_action_pressed("weapon_2"):
		switch_weapon(weapons[1])

func get_player_aim_input(delta):
	aim_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	if aim_dir.length() > dead_zone:
		var aim_angle: float = aim_dir.angle()
		current_weapon.global_rotation = rotate_toward(current_weapon.global_rotation, aim_angle, 2 * delta)
