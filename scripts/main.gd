extends Node2D

@onready var bullet_manager = $BulletManager




func _on_player_player_shot(bullet, bullet_start_location, bullet_dir):
	bullet_manager.handle_bullet_spawned(bullet, bullet_start_location, bullet_dir)
