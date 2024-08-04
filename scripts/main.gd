extends Node2D


@onready var capturable_base_manager = $CapturableBaseManager
@onready var ally_map_ai = $AllyMapAI
@onready var enemy_map_ai = $EnemyMapAI
@onready var bullet_manager = $BulletManager
@onready var player = $Player


func _ready():
	GlobalSignals.connect("bullet_fired", bullet_manager.handle_bullet_spawned)
	var bases = capturable_base_manager.get_capturable_bases()
	ally_map_ai.initialize(bases)
	enemy_map_ai.initialize(bases)
