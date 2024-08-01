extends Node2D
class_name Weapon


signal weapon_fired(bullet, bullet_start_postion, bullet_direction)


@export var BulletScene: PackedScene
@onready var end_of_gun = $EndOfGun
@onready var gun_direction = $GunDirection
@onready var weapon_cooldown = $WeaponCooldown
@onready var animation_player = $AnimationPlayer


func shoot():
	if weapon_cooldown.is_stopped():
		var bullet_instance = BulletScene.instantiate()
		var bullet_direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		GlobalSignals.bullet_fired.emit(bullet_instance, end_of_gun.global_position, bullet_direction)
		#weapon_fired.emit(bullet_instance, end_of_gun.global_position, bullet_direction)
		weapon_cooldown.start()
		animation_player.play("muzzle_flash")
