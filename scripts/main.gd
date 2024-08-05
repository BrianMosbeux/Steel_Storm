extends Node2D


@onready var capturable_base_manager = $CapturableBaseManager
@onready var ally_map_ai = $AllyMapAI
@onready var enemy_map_ai = $EnemyMapAI
@onready var bullet_manager = $BulletManager
@onready var player = $Player


func _ready():
	GlobalSignals.connect("bullet_fired", bullet_manager.handle_bullet_spawned)
	var bases = capturable_base_manager.get_capturable_bases()
	var ally_respawn_points = $AllyRespawnPoints.get_children()
	var enemy_respawn_points = $EnemyRespawnPoints.get_children()
	ally_map_ai.initialize(bases, ally_respawn_points)
	enemy_map_ai.initialize(bases, enemy_respawn_points)
