extends Node2D


@onready var capturable_base_manager = $CapturableBaseManager
@onready var ally_map_ai = $AllyMapAI
@onready var enemy_map_ai = $EnemyMapAI
@onready var bullet_manager = $BulletManager
@onready var player: Player
@onready var path_finding = $PathFinding
@onready var tile_map = $TileMap


func _ready():
	GlobalSignals.connect("bullet_fired", bullet_manager.handle_bullet_spawned)
	var bases = capturable_base_manager.get_capturable_bases()
	var ally_respawn_points = $AllyRespawnPoints.get_children()
	var enemy_respawn_points = $EnemyRespawnPoints.get_children()
	ally_map_ai.initialize(bases, ally_respawn_points, path_finding)
	enemy_map_ai.initialize(bases, enemy_respawn_points, path_finding)
	path_finding.create_astar_grid_2d(tile_map)
	
	# test path_finding
	path_finding.get_new_path(ally_respawn_points[0].global_position, bases[0].global_position)
	
