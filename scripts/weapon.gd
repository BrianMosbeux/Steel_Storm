extends Node2D
class_name Weapon


signal weapon_ammo_count_changed(new_ammo_count)
signal weapon_out_of_ammo


const TANK_BLUE_BARREL_1_OUTLINE: Texture = preload("res://assets/sprites/tank_blue/tankBlue_barrel2_outline.png")
const TANK_RED_BARREL_1_OUTLINE: Texture = preload("res://assets/sprites/tank_red/tankRed_barrel2_outline.png")


@export var BulletScene: PackedScene

var weapon_sprites: Dictionary = {
	1: TANK_BLUE_BARREL_1_OUTLINE,
	2: TANK_RED_BARREL_1_OUTLINE
}
var team: int = -1
var max_ammo: int = 5
var current_ammo: int = max_ammo:
	set(new_ammo_count):
		var actual_ammo = clamp(new_ammo_count, 0, max_ammo)
		if current_ammo != actual_ammo:
			current_ammo = actual_ammo
			if current_ammo == 0:
				weapon_out_of_ammo.emit()
			weapon_ammo_count_changed.emit(current_ammo)
var reloading: bool


@onready var end_of_gun = $EndOfGun
@onready var weapon_cooldown = $WeaponCooldown
@onready var animation_player = $AnimationPlayer
@onready var muzzle_flash = $MuzzleFlash
@onready var tank_barrel_sprite = $TankBarrel2Sprite

func _ready():
	muzzle_flash.hide()
	
func initialize(team: int, weapon_sprite: Texture = weapon_sprites[team]):
	self.team = team
	self.tank_barrel_sprite.texture = weapon_sprite

func start_reload():
	reloading = true
	animation_player.play("reload")
	
func _stop_reload():
	reloading = false
	current_ammo = max_ammo

func shoot():
	if weapon_cooldown.is_stopped() and current_ammo != 0:
		var bullet_instance = BulletScene.instantiate()
		var bullet_direction = (end_of_gun.global_position - global_position).normalized()
		GlobalSignals.bullet_fired.emit(bullet_instance, end_of_gun.global_position, bullet_direction)
		weapon_cooldown.start()
		animation_player.play("muzzle_flash")
		current_ammo -= 1
