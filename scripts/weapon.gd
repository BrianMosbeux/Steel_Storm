extends Node2D
class_name Weapon


signal weapon_out_of_ammo


@export var BulletScene: PackedScene


var max_ammo: int = 5
var current_ammo: int = max_ammo


@onready var end_of_gun = $EndOfGun
@onready var gun_direction = $GunDirection
@onready var weapon_cooldown = $WeaponCooldown
@onready var animation_player = $AnimationPlayer


func start_reload():
	animation_player.play("reload")
	
func _stop_reload():
	current_ammo = max_ammo

func shoot():
	if weapon_cooldown.is_stopped() and current_ammo != 0:
		var bullet_instance = BulletScene.instantiate()
		var bullet_direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		GlobalSignals.bullet_fired.emit(bullet_instance, end_of_gun.global_position, bullet_direction)
		weapon_cooldown.start()
		animation_player.play("muzzle_flash")
		current_ammo -= 1
		if current_ammo == 0:
			weapon_out_of_ammo.emit()
