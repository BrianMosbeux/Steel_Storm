extends Node2D
class_name Weapon


signal weapon_ammo_count_changed(new_ammo_count)
signal weapon_out_of_ammo


@export var BulletScene: PackedScene


var max_ammo: int = 5
var current_ammo: int = max_ammo:
	set(new_ammo_count):
		var actual_ammo = clamp(new_ammo_count, 0, max_ammo)
		if current_ammo != actual_ammo:
			current_ammo = actual_ammo
			if current_ammo == 0:
				weapon_out_of_ammo.emit()
			weapon_ammo_count_changed.emit(current_ammo)


@onready var end_of_gun = $EndOfGun
@onready var weapon_cooldown = $WeaponCooldown
@onready var animation_player = $AnimationPlayer
@onready var muzzle_flash = $MuzzleFlash

func _ready():
	muzzle_flash.hide()

func start_reload():
	animation_player.play("reload")
	
func _stop_reload():
	current_ammo = max_ammo

func shoot():
	if weapon_cooldown.is_stopped() and current_ammo != 0:
		var bullet_instance = BulletScene.instantiate()
		var bullet_direction = (end_of_gun.global_position - global_position).normalized()
		GlobalSignals.bullet_fired.emit(bullet_instance, end_of_gun.global_position, bullet_direction)
		weapon_cooldown.start()
		animation_player.play("muzzle_flash")
		current_ammo -= 1
