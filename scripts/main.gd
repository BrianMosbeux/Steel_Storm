extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player = $Player


func _ready():
	GlobalSignals.connect("bullet_fired", bullet_manager.handle_bullet_spawned)
